-- IV. CREATE TRIGGER
-- Kiem tra vi pham vung bien
CREATE OR REPLACE TRIGGER TRG_check_VI_PHAM
AFTER INSERT ON LOG_HAI_TRINH
FOR EACH ROW
DECLARE
    v_poly SDO_GEOMETRY;
    v_Count NUMBER;
BEGIN
    v_Count := 0;

    SELECT nt.ViTri
    INTO v_poly
    FROM CHUYEN_DANH_BAT cdb
    JOIN NGU_TRUONG nt ON nt.MaNguTruong = cdb.MaNguTruong
    WHERE cdb.MaChuyenDanhBat = :NEW.MaChuyenDanhBat;

    SELECT count(*)
    INTO v_Count
    FROM VI_PHAM vp
    WHERE vp.MaChuyenDanhBat = :NEW.MaChuyenDanhBat;

    IF SDO_CONTAINS(v_poly, :NEW.ViTri) = 'FALSE' AND v_Count = 0 THEN
        insert_VI_PHAM(:NEW.MaChuyenDanhBat, :NEW.ViTri, 'Vi pham vung bien');
    END IF;
END;
/

-- CAP NHAT SAN LUONG CHUYEN DANH BAT
CREATE OR REPLACE TRIGGER TRG_update_weight
AFTER INSERT ON DANHBAT_THUYSAN
FOR EACH ROW
BEGIN
    UPDATE ME_CA
    SET KhoiLuongMeCa = KhoiLuongMeCa + :NEW.KhoiLuong
    WHERE MaMeCa = :NEW.MaMeCa AND MaChuyenDanhBat = :NEW.MaChuyenDanhBat;

    UPDATE CHUYEN_DANH_BAT
    SET TongKhoiLuong = TongKhoiLuong + :NEW.KhoiLuong
    WHERE MaChuyenDanhBat = :NEW.MaChuyenDanhBat;

    EXCEPTION
    WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20010,
            'Error in TRG_update_weight: ' || SQLERRM);
END;
/

-- V. CREATE PROCEDURE

-- PROCEDURE LAY DU LIEU
-- Lay danh sach TAU_CA cua CHU_TAU
CREATE OR REPLACE PROCEDURE get_owner_ships_list(
    p_cursor OUT SYS_REFCURSOR,
    p_MaChuTau   CHU_TAU.MaChuTau%TYPE
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM TAU_CA t WHERE t.MaChuTau = p_MaChuTau;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Lay danh sach CHU_TAU CHO DUYET
CREATE OR REPLACE PROCEDURE get_owners_info_pending(
    chu_tau_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN chu_tau_cursor FOR
        SELECT * FROM CHU_TAU ct
        WHERE ct.TrangThaiDuyet = 'DANG CHO';
END;
/

-- Lay danh sach TAU_CA CHO DUYET
CREATE OR REPLACE PROCEDURE get_ships_info_pending(
    p_cursor OUT SYS_REFCURSOR
) 
IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM TAU_CA tc
        WHERE tc.TrangThaiDuyet = 'DANG CHO';
END;
/

-- Lay danh sach TAU_CA va trang thai hoat dong TAU_CA cua CHU_TAU
CREATE OR REPLACE PROCEDURE get_owner_ships_list_and_status(
    tau_ca_cursor OUT SYS_REFCURSOR,
    p_MaChuTau        TAU_CA.p_MaChuTau%TYPE
)
IS
BEGIN
    OPEN tau_ca_cursor FOR
        SELECT tc.MaTauCa, tc.TrangThaiHoatDong 
        FROM TAU_CA tc 
        WHERE tc.MaChuTau = p_MaChuTau;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Lay danh sach tat ca TAU_CA DANG HOAT DONG
CREATE OR REPLACE PROCEDURE get_working_ships_list(
    
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM TAU_CA t WHERE t.TRANGTHAIHOATDONG ='DANG HOAT DONG';

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Lay danh sach cac NGU_TRUONG
CREATE OR REPLACE PROCEDURE get_fishery_list(
    ngu_truong_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN ngu_truong_cursor FOR
        SELECT ng.MANGUTRUONG,ng.TENNGUTRUONG FROM NGU_TRUONG ng;
END;
/

-- Lay thong tin NGU_TRUONG
CREATE OR REPLACE PROCEDURE get_fishery_info(
    ngu_truong_cursor OUT SYS_REFCURSOR,
    p_MaNguTruong NVARCHAR2
)
IS
    v_Count NUMBER;
BEGIN
    -- Kiem tra ma ngu truong co ton tai khong
    -- Neu khong ton tai, thi bao loi
    SELECT COUNT(*)
    INTO v_Count
    FROM NGU_TRUONG ng
    WHERE ng.MANGUTRUONG = p_MaNguTruong;

    IF v_Count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Ngu truong khong ton tai');
    END IF; 


    OPEN ngu_truong_cursor FOR
        SELECT* FROM NGU_TRUONG ng WHERE ng.MANGUTRUONG = p_MaNguTruong; 
    

END;
/

-- Lay thong tin THOI_TIET moi nhat
CREATE OR REPLACE PROCEDURE get_newest_weather_info(
    weather_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN weather_cursor FOR
        SELECT *
        FROM (
            SELECT *
            FROM THOI_TIET
            ORDER BY ThoiGianDuBao DESC
        )
        WHERE ROWNUM = 1;
END;
/

-- Lay danh sach BAO
CREATE OR REPLACE PROCEDURE get_storm_list(
    bao_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN bao_cursor FOR
        SELECT * FROM BAO;
END;
/

-- Lay thong tin chi tiet BAO
CREATE OR REPLACE PROCEDURE get_storm_info(
    bao_cursor OUT SYS_REFCURSOR,
    p_MaBao NVARCHAR2
)
IS
BEGIN
    OPEN bao_cursor FOR
        SELECT * FROM LOG_DUONG_DI_BAO b
        WHERE b.MABAO = p_MaBao;
END;
/

-- PROCEDURE XU LY
-- Tao admin
CREATE OR REPLACE PROCEDURE insert_ADMIN(
    p_USERNAME      APP_USER.USERNAME%TYPE,
    p_PASSWORD      APP_USER.PASSWORD%TYPE,
    p_HoTen         ADMIN.HoTen%TYPE,
    p_CoQuan        ADMIN.CoQuan%TYPE,
    p_CCCD          ADMIN.CCCD%TYPE
)
IS
    p_MaAdmin       ADMIN.MaAdmin%TYPE;
BEGIN
    INSERT INTO APP_USER(USERNAME, PASSWORD, ROLE)
    VALUES(p_USERNAME, p_PASSWORD, 'ADMIN');

    SELECT USER_ID
    INTO p_MaAdmin
    FROM APP_USER
    WHERE USERNAME = p_USERNAME;

    INSERT INTO ADMIN(MaAdmin, HoTen, CoQuan, CCCD)
    VALUES(p_MaAdmin, p_HoTen, p_CoQuan, p_CCCD);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

--1 THONG TIN DANG KY 

-- DANG KY THONG TIN CHU_TAU
-- Tao CHU_TAU
CREATE OR REPLACE PROCEDURE insert_CHU_TAU(
    p_USERNAME      APP_USER.USERNAME%TYPE,
    p_PASSWORD      APP_USER.PASSWORD%TYPE,
    p_HoTen         CHU_TAU.HoTen%TYPE,
    p_SDT           CHU_TAU.SDT%TYPE,
    p_DiaChi        CHU_TAU.DiaChi%TYPE,
    p_CCCD          CHU_TAU.CCCD%TYPE
)
IS
    p_MaChuTau      CHU_TAU.MaChuTau%TYPE;
BEGIN
    INSERT INTO APP_USER(USERNAME, PASSWORD)
    VALUES(p_USERNAME, p_PASSWORD);

    SELECT USER_ID
    INTO p_MaChuTau
    FROM APP_USER
    WHERE USERNAME = p_USERNAME;

    INSERT INTO CHU_TAU(MaChuTau, HoTen, SDT, DiaChi, CCCD)
    VALUES(p_MaChuTau, p_HoTen, p_SDT, NULLIF(TRIM(p_DiaChi), ''), p_CCCD);
    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;

END;
/

-- DANG KY THONG TIN TAU_CA
-- Insert NGHE
CREATE OR REPLACE PROCEDURE insert_NGHE(
    p_TenNghe       NGHE.TenNghe%TYPE
)
IS
BEGIN
    INSERT INTO NGHE(TenNghe)
    VALUES (p_TenNghe);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

-- Tao TAU_CA
CREATE OR REPLACE PROCEDURE insert_TAU_CA(
    p_SoDangKy           TAU_CA.SoDangKy%TYPE,
    p_LoaiTau            TAU_CA.LoaiTau%TYPE,
    p_ChieuDai           TAU_CA.ChieuDai%TYPE,
    p_CongSuat           TAU_CA.CongSuat%TYPE,
    p_NamDongTau         TAU_CA.NamDongTau%TYPE,
    p_MaChuTau           TAU_CA.MaChuTau%TYPE,
    p_MaNgheChinh        TAU_CA.MaNgheChinh%TYPE
)
IS
    p_TrangThaiDuyetChuTau  CHUTAU.TrangThaiDuyet%TYPE;
BEGIN
    SELECT TrangThaiDuyet
    INTO p_TrangThaiDuyetChuTau
    FROM CHU_TAU
    WHERE MaChuTau = p_MaChuTau;

    IF p_TrangThaiDuyetChuTau = 'DA DUYET' THEN
        INSERT INTO TAU_CA(SoDangKy, LoaiTau, ChieuDai, CongSuat, NamDongTau, MaChuTau, MaNgheChinh)
        VALUES (p_SoDangKy, p_LoaiTau, p_ChieuDai, p_CongSuat, p_NamDongTau, p_MaChuTau, p_MaNgheChinh);
    ELSE
        RAISE_APPLICATION_ERROR(-number, 'HO SO CHU TAU CHUA DUOC DUYET');
    END IF;

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Insert NGHE cho TAU_CA
CREATE OR REPLACE PROCEDURE insert_TAU_NGHE(
    p_MaTauCa            TAU_NGHE.MaTauCa%TYPE,
    p_MaNghe             TAU_NGHE.MaNghe%TYPE,
    p_VungHoatDong       TAU_NGHE.VungHoatDong%TYPE
)
IS
BEGIN
    INSERT INTO TAU_NGHE(MaTauCa, MaNghe, VungHoatDong)
    VALUES (p_MaTauCa, p_MaNghe, p_VungHoatDong);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- DUYET THONG TIN CHU_TAU
-- Xem PROCEDURE LAY DU LIEU
-- Cap nhat trang thai duyet CHU_TAU
CREATE OR REPLACE PROCEDURE update_approval_status_CHU_TAU(
    p_TrangThaiDuyet    CHU_TAU.TrangThaiDuyet%TYPE,
    p_MaChuTau          CHU_TAU.MaChuTau%TYPE
)
IS
BEGIN
    UPDATE CHU_TAU
    SET TrangThaiDuyet = p_TrangThaiDuyet
    WHERE MaChuTau = p_MaChuTau;
END;
/

-- DUYET THONG TIN TAU_CA
-- Xem PROCEDURE LAY DU LIEU
-- Cap nhat trang thai duyet TAU_CA
CREATE OR REPLACE PROCEDURE update_approval_status_TAU_CA(
    p_TrangThaiDuyet    TAU_CA.TrangThaiDuyet%TYPE,
    p_MaTauCa           TAU_CA.MaTauCa%TYPE
)
IS
BEGIN
    UPDATE TAU_CA
    SET TrangThaiDuyet = p_TrangThaiDuyet
    WHERE MaTauCa = p_MaTauCa;
END;
/

-- CAP NHAT THONG TIN CHU_TAU
-- Update CHU_TAU
CREATE OR REPLACE PROCEDURE update_info_CHU_TAU(
    p_MaChuTau        CHU_TAU.MaChuTau%TYPE,
    p_HoTen           CHU_TAU.HoTen%TYPE,
    p_SDT             CHU_TAU.SDT%TYPE,
    p_DiaChi          CHU_TAU.DiaChi%TYPE,
    p_CCCD            CHU_TAU.CCCD%TYPE
)
IS
BEGIN
    UPDATE CHU_TAU
    SET HoTen = p_HoTen,
        SDT = p_SDT,
        DiaChi = p_DiaChi,
        CCCD = p_CCCD,
        TrangThaiDuyet = 'DANG CHO'
    WHERE MaChuTau = p_MaChuTau;
END;
/

-- CAP NHAT THONG TIN TAU_CA
-- Update TAU_CA
CREATE OR REPLACE PROCEDURE update_info_TAU_CA(
    p_MaTauCa            TAU_CA.MaTauCa%TYPE,
    p_SoDangKy           TAU_CA.SoDangKy%TYPE,
    p_LoaiTau            TAU_CA.LoaiTau%TYPE,
    p_ChieuDai           TAU_CA.ChieuDai%TYPE,
    p_CongSuat           TAU_CA.CongSuat%TYPE,
    p_NamDongTau         TAU_CA.NamDongTau%TYPE,
    p_MaNgheChinh        TAU_CA.MaNgheChinh%TYPE
)
IS
BEGIN
    UPDATE TAU_CA
    SET SoDangKy = p_SoDangKy,
        LoaiTau = p_LoaiTau,
        ChieuDai = p_ChieuDai,
        CongSuat = p_CongSuat,
        NamDongTau = p_NamDongTau,
        TrangThaiDuyet = 'DANG CHO',
        MaNgheChinh = p_MaNgheChinh
    WHERE MaTauCa = p_MaTauCa;

END;
/

-- THEO DOI TRANG THAI DUYET CHU_TAU
-- Lay trang thai duyet CHU_TAU
CREATE OR REPLACE PROCEDURE get_approval_status_CHU_TAU(
     chu_tau_cursor OUT SYS_REFCURSOR,
     p_MaChuTau         CHU_TAU.MaChuTau%TYPE
)
IS
BEGIN
    OPEN chu_tau_cursor FOR
        SELECT ct.TrangThaiDuyet
        FROM CHU_TAU ct
        WHERE ct.MaChuTau = p_MaChuTau;
END;
/

-- THEO DOI TRANG THAI DUYET TAU_CA
-- Lay danh sau TAU_CA va trang thai duyet TAU_CA
CREATE OR REPLACE PROCEDURE get_approval_status_TAU_CA(
    tau_ca_cursor OUT SYS_REFCURSOR,
    p_MaChuTau        CHU_TAU.MaChuTau%TYPE
)
IS
BEGIN
    OPEN tau_ca_cursor FOR
        SELECT tc.MaTauCa, tc.SoDangKy, tc.TrangThaiDuyet
        FROM TAU_CA tc
        WHERE tc.MaChuTau = p_MaChuTau;
END;
/

-- 2.HOAT DONG DANH BAT BAT

-- DANG KY THONG TIN CHUYEN DANH BAT
-- Tao CHUYEN_DANH_BAT
CREATE OR REPLACE PROCEDURE insert_CHUYEN_DANH_BAT(
    p_MaTauCa             CHUYEN_DANH_BAT.MaTauCa%TYPE,
    p_MaNguTruong         CHUYEN_DANH_BAT.MaNguTruong%TYPE
)
IS
    p_TrangThaiDuyetChuTau          CHU_TAU.TrangThaiDuyet%TYPE;
    p_TrangThaiDuyetTauCa           TAU_CA.TrangThaiDuyet%TYPE;
    p_TrangThaiHoatDongTauCa        TAU_CA.TrangThaiDuyet%TYPE;
    p_KtraSoLuongTau                BOOLEAN;
BEGIN
    SELECT ct.TrangThaiDuyet, tc.TrangThaiDuyet, tc.TrangThaiHoatDong
    INTO p_TrangThaiDuyetChuTau, p_TrangThaiDuyetTauCa, p_TrangThaiHoatDongTauCa
    FROM TAU_CA tc JOIN CHU_TAU ct ON tc.MaChuTau = ct.MACHUTAU
    WHERE tc.MaTauCa = p_MaTauCa;

    p_KtraSoLuongTau := Fn_kiem_tra_so_luong_tau(p_MaNguTruong);

    IF p_TrangThaiDuyetChuTau = 'DA DUYET' AND p_TrangThaiDuyetTauCa = 'DA DUYET' AND p_TrangThaiHoatDongTauCa = 'DANG CHO|CHUA DK' AND p_KtraSoLuongTau = TRUE THEN
        INSERT INTO CHUYEN_DANH_BAT(
            MaTauCa,
            MaNguTruong
        )
        VALUES(
            p_MaTauCa,
            p_MaNguTruong
        );

        UPDATE NGU_TRUONG
        SET SoLuongTauHienTai = SoLuongTauHienTai + 1
        WHERE MaNguTruong = p_MaNguTruong;

        UPDATE TAU_CA
        SET TrangThaiHoatDong = 'DANG CHO|DA DK'
        WHERE MaTauCa = p_MaTauCa;

    ELSIF p_TrangThaiHoatDongTauCa != 'DANG CHO|CHUA DK' THEN
        RAISE_APPLICATION_ERROR(-20001, 'TAU DA DUOC DANG KY');
    ELSIF p_KtraSoLuongTau = FALSE THEN
        RAISE_APPLICATION_ERROR(-20002, 'SO LUONG TAU O NGU TRUONG DAT TOI DA');
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'HO SO CHU TAU HOAC HO SO TAU CA CHUA DUOC DUYET');
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- DUYET THONG TIN CHUYEN DANH BAT
-- Cap nhat trang thai duyet CHUYEN_DANH_BAT
CREATE OR REPLACE PROCEDURE update_approval_status_CHUYEN_DANH_BAT(
    p_TrangThaiDuyet    CHUYEN_DANH_BAT.TrangThaiDuyet%TYPE,
    p_MaChuyenDanhBat   CHUYEN_DANH_BAT.MaChuyenDanhBat%TYPE
)
IS
    p_MaNguTruong    CHUYEN_DANH_BAT.MaNguTruong%TYPE;
    p_MaTauCa        CHUYEN_DANH_BAT.MaTauCa%TYPE;
BEGIN
    IF p_TrangThaiDuyet = 'DA DUYET' THEN
        UPDATE CHUYEN_DANH_BAT
        SET TrangThaiDuyet = p_TrangThaiDuyet
        WHERE MaChuyenDanhBat = p_MaChuyenDanhBat;
    ELSE
        UPDATE CHUYEN_DANH_BAT
        SET TrangThaiDuyet = p_trangthaiduyet
        WHERE MaChuyenDanhBat = p_MaChuyenDanhBat;

        SELECT MaTauCa, MaNguTruong
        INTO p_MaTauCa, p_MaNguTruong
        FROM CHUYEN_DANH_BAT
        WHERE MaChuyenDanhBat = p_MaChuyenDanhBat; 

        UPDATE TAU_CA
        SET TrangThaiHoatDong = 'DANG CHO|CHUA DK'
        WHERE MaTauCa = p_MaTauCa;

        UPDATE NGU_TRUONG
        SET SoLuongTauHienTai = SoLuongTauHienTai - 1
        WHERE MaNguTruong = p_MaNguTruong;
    END IF;
END;
/

-- GIAM SAT DANH BAT
-- Lay thong tin vi tri moi nhat cua tat ca tau
CREATE OR REPLACE PROCEDURE get_newest_location_info_all(
    p_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
  OPEN p_cursor FOR
    SELECT MaTauCa, ThoiGian, ViTriWKT, VanToc, HuongDiChuyen
    FROM (
        SELECT tc.MaTauCa, lht.ThoiGian,
            DBMS_LOB.SUBSTR(SDO_UTIL.TO_WKTGEOMETRY(lht.ViTri), 4000, 1) AS ViTriWKT,
            lht.VanToc, lht.HuongDiChuyen,
            ROW_NUMBER() OVER (
            PARTITION BY tc.MaTauCa
            ORDER BY lht.ThoiGian DESC
            ) AS rn
        FROM TAU_CA tc
        JOIN CHUYEN_DANH_BAT cdb ON cdb.MaTauCa = tc.MaTauCa
        JOIN LOG_HAI_TRINH lht ON lht.MaChuyenDanhBat = cdb.MaChuyenDanhBat
    )
    WHERE rn = 1;
END;
/

-- GIAM SAT TAU_CA TRONG DOI TAU
-- Lay thong tin vi tri moi nhat cua cac tau trong doi tau
CREATE OR REPLACE PROCEDURE get_newest_location_info_owner(
    p_cursor OUT SYS_REFCURSOR,
    p_MaChuTau      TAU_CA.MaChuTau%TYPE
)
IS
BEGIN
  OPEN p_cursor FOR
    SELECT MaTauCa, ThoiGian, ViTriWKT, VanToc, HuongDiChuyen
    FROM (
        SELECT tc.MaTauCa, lht.ThoiGian,
            DBMS_LOB.SUBSTR(SDO_UTIL.TO_WKTGEOMETRY(lht.ViTri), 4000, 1) AS ViTriWKT,
            lht.VanToc, lht.HuongDiChuyen,
            ROW_NUMBER() OVER (
            PARTITION BY tc.MaTauCa
            ORDER BY lht.ThoiGian DESC
            ) AS rn
        FROM TAU_CA tc
        JOIN CHUYEN_DANH_BAT cdb ON cdb.MaTauCa = tc.MaTauCa
        JOIN LOG_HAI_TRINH lht ON lht.MaChuyenDanhBat = cdb.MaChuyenDanhBat
        WHERE tc.MaChuTau = p_MaChuTau
    )
    WHERE rn = 1;
END;
/

-- CAP NHAT TRANG THAI ROI / CAP CANG
-- Cap nhat trang thai roi cang
CREATE OR REPLACE PROCEDURE update_working_status_depart(
    p_MaTauCa   CHUYEN_DANH_BAT.MaTauCa%TYPE,
    p_CangDi    CHUYEN_DANH_BAT.CangDi%TYPE
)
IS
    p_MaChuyenDanhBat               CHUYEN_DANH_BAT.MaChuyenDanhBat%TYPE;
    p_TrangThaiHoatDongTauCa        TAU_CA.TrangThaiHoatDong%TYPE;
    p_TrangThaiDuyetCDB             CHUYEN_DANH_BAT.TrangThaiDuyet%TYPE;
BEGIN
    SELECT TrangThaiHoatDong
    INTO p_TrangThaiHoatDongTauCa
    FROM TAU_CA
    WHERE MaTauCa = p_MaTauCa;

    IF p_TrangThaiHoatDongTauCa = 'DANG CHO|CHUA DK' THEN
        RAISE_APPLICATION_ERROR(-20004, 'TAU CHUA DANG KY CHUYEN DANH BAT');
    ELSIF p_TrangThaiHoatDongTauCa = 'DANG HOAT DONG' THEN
        RAISE_APPLICATION_ERROR(-20005, 'TAU DANG HOAT DONG, KHONG THE DUNG CHUC NANG NAY');
    END IF;

    SELECT MaChuyenDanhBat
    INTO p_MaChuyenDanhBat
    FROM CHUYEN_DANH_BAT
    WHERE MaTauCa = p_MaTauCa AND TrangThaiHoatDong = 'DANG CHO';

    SELECT TrangThaiDuyet
    INTO p_TrangThaiDuyetCDB
    FROM CHUYEN_DANH_BAT
    WHERE MaChuyenDanhBat = p_MaChuyenDanhBat;

    IF p_TrangThaiDuyetCDB = 'CHO DUYET' THEN
        RAISE_APPLICATION_ERROR(-20006, 'CHUYEN DANH BAT CHUA DUOC DUYET');
    ELSIF p_TrangThaiDuyetCDB = 'TU CHOI' THEN
        RAISE_APPLICATION_ERROR(-20007, 'CHUYEN DANH BAT BI TU CHOI');
    END IF;

    UPDATE TAU_CA
    SET TrangThaiHoatDong = 'DANG HOAT DONG'
    WHERE MaTauCa = p_MaTauCa;

    UPDATE CHUYEN_DANH_BAT
    SET TrangThaiHoatDong = 'DANG DANH BAT',
        CangDi = p_CangDi,
        NgayXuatBen = SYSDATE
    WHERE MaTauCa = p_MaTauCa;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Cap nhat trang thai cap cang
CREATE OR REPLACE PROCEDURE update_working_status_dock(
    p_MaTauCa   CHUYEN_DANH_BAT.MaTauCa%TYPE,
    p_CangVe    CHUYEN_DANH_BAT.CangVe%TYPE
)
IS
    p_MaChuyenDanhBat               CHUYEN_DANH_BAT.MaChuyenDanhBat%TYPE;
    p_TrangThaiHoatDongTauCa        TAU_CA.TrangThaiHoatDong%TYPE;
    p_TrangThaiDuyetCDB             CHUYEN_DANH_BAT.TrangThaiDuyet%TYPE;
    p_MaNguTruong                   CHUYEN_DANH_BAT.MaNguTruong%TYPE;
BEGIN
    SELECT TrangThaiHoatDong
    INTO p_TrangThaiHoatDongTauCa
    FROM TAU_CA
    WHERE MaTauCa = p_MaTauCa;

    IF p_TrangThaiHoatDongTauCa = 'DANG HOAT DONG' THEN
        SELECT MaChuyenDanhBat, MaNguTruong
        INTO p_MaChuyenDanhBat, p_MaNguTruong
        FROM CHUYEN_DANH_BAT
        WHERE MaTauCa = p_MaTauCa AND TrangThaiHoatDong = 'DANG DANH BAT';

        UPDATE TAU_CA
        SET TrangThaiHoatDong = 'DANG CHO|CHUA DK'
        WHERE MaTauCa = p_MaTauCa;

        UPDATE CHUYEN_DANH_BAT
        SET TrangThaiHoatDong = 'HOAN THANH',
            CangVe = p_CangVe,
            NgayCapBen = SYSDATE
        WHERE MaTauCa = p_MaTauCa;

        UPDATE NGU_TRUONG
        SET SoLuongTauHienTai = SoLuongTauHienTai - 1
        WHERE MaNguTruong = p_MaNguTruong;
    ELSE 
        RAISE_APPLICATION_ERROR(-20008, 'TAU HIEN TAI KHONG HOAT DONG');
    END IF;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- CAP NHAT NHAT KY DANH BAT
-- Insert ME_CA
CREATE OR REPLACE PROCEDURE insert_ME_CA(
    p_MaChuyenDanhBat   CHUYENDANHBAT.MaChuyenDanhBat%TYPE,
    p_ThoiGianThaLuoi     CHUYENDANHBAT.ThoiGianThaLuoi%TYPE,
    p_ThoiGianKeoLuoi     CHUYENDANHBAT.ThoiGianKeoLuoi%TYPE,
    p_ViTriKeoLuoi        CHUYENDANHBAT.ViTriKeoLuoi%TYPE
)
IS
BEGIN
    INSERT INTO ME_CA(MaChuyenDanhBat, ThoiGianThaLuoi, ThoiGianKeoLuoi, ViTriKeoLuoi)
    VALUES (p_MaChuyenDanhBat, p_ThoiGianThaLuoi, p_ThoiGianKeoLuoi, p_ViTriKeoLuoi);
END;
/

--Insert CHI TIET ME_CA
CREATE OR REPLACE PROCEDURE insert_DANHBAT_THUYSAN(
    p_MaChuyenDanhBat       CHUYENDANHBAT.MaChuyenDanhBat%TYPE,
    p_MaMeCa                CHUYENDANHBAT.MaMeCa%TYPE,
    p_MaThuySan             CHUYENDANHBAT.MaThuySan%TYPE,
    p_KhoiLuong             CHUYENDANHBAT.KhoiLuong%TYPE
)
IS
BEGIN
    INSERT INTO DANHBAT_THUYSAN(MaChuyenDanhBat, MaMeCa, MaThuySan, KhoiLuong)
    VALUES (p_MaChuyenDanhBat, p_MaMeCa, p_MaThuySan, p_KhoiLuong);
END;
/

-- THEO DOI HAI TRINH
-- Lay danh sach LOG toa do
CREATE OR REPLACE PROCEDURE get_log_list_CHUYEN_DANH_BAT(
    p_cursor OUT SYS_REFCURSOR,
    p_MaChuyenDanhBat   CHUYEN_DANH_BAT.MaChuyenDanhBat%TYPE
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT lht.MaLogHaiTrinh, lht.ThoiGian, lht.ViTri, lht.VanToc, lht.HuongDiChuyen
        FROM LOG_HAI_TRINH lht
        WHERE lht.MaChuyenDanhBat = p_MaChuyenDanhBat;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- CAP NHAT VI TRI TAU
-- Them 1 diem toa do vao LOG
CREATE OR REPLACE PROCEDURE insert_LOG_HAI_TRINH_for_CHUYEN_DANH_BAT(
    p_MaChuyenDanhBat     LOG_HAI_TRINH.MaChuyenDanhBat%TYPE,
    p_ThoiGian            LOG_HAI_TRINH.ThoiGian%TYPE,
    p_ViTri               VARCHAR2,
    p_VanToc              LOG_HAI_TRINH.VanToc%TYPE,
    p_HuongDiChuyen       LOG_HAI_TRINH.HuongDiChuyen%TYPE
)
IS
   v_exists NUMBER; 
BEGIN
    SELECT COUNT(*) 
        INTO v_exists
        FROM CHUYEN_DANH_BAT
    WHERE MaChuyenDanhBat = p_MaChuyenDanhBat;

    IF v_exists = 0 THEN
        RAISE_APPLICATION_ERROR(
            -20010, 
            'MaChuyenDanhBat "' || p_MaChuyenDanhBat || '" khong ton tai.'
        );
    END IF;

    INSERT INTO LOG_HAI_TRINH(MaChuyenDanhBat, ThoiGian, ViTri, VanToc, HuongDiChuyen)
    VALUES (p_MaChuyenDanhBat, p_ThoiGian, SDO_UTIL.FROM_WKTGEOMETRY(p_ViTri), p_VanToc, p_HuongDiChuyen);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- TRUY XUAT NHAT KY DANH BAT
-- Lay nhat ky danh bat
CREATE OR REPLACE PROCEDURE get_fishing_diary(
    thong_tin_tau_cursor OUT SYS_REFCURSOR,
    thong_tin_danh_bat_cursor OUT SYS_REFCURSOR,
    p_MaChuyenDanhBat          CHUYEN_DANH_BAT.MaChuyenDanhBatTauCa%TYPE 
)
IS
BEGIN
    OPEN thong_tin_tau_cursor FOR 
        SELECT 
            ct.HoTen,
            tc.MaTauCa, tc.SoDangKy, tc.LoaiTau, tc.ChieuDai, tc.CongSuat,
            nghe_chinh.TenNghe,
            cdb.MaChuyenDanhBat, cdb.NgayXuatBen, cdb.NgayCapBen, cdb.CangDi, cdb.CangVe,
            nghe_chinh.TenNghe
        FROM CHUYEN_DANH_BAT cdb
        JOIN CHU_TAU ct ON ct.MaChuTau = cdb.MaChuTau
        JOIN TAU_CA tc ON tc.MaTauCa = cdb.MaTauCa
        JOIN NGHE nghe_chinh ON nghe_chinh.MaNghe = tc.MaNgheChinh
        JOIN TAU_NGHE tau_nghe ON tau_nghe.MaTauCa = tc.MaTauCa
        WHERE cdb.MaChuyenDanhBat = p_MaChuyenDanhBat;

    OPEN thong_tin_danh_bat_cursor FOR 
        SELECT 
            mc.MaMeCa, 
            mc.KhoiLuongMeCa, 
            mc.ThoiGianThaLuoi, 
            mc.ThoiGianKeoLuoi, 
            DBMS_LOB.SUBSTR(SDO_UTIL.TO_WKTGEOMETRY(mc.ViTriKeoLuoi), 4000, 1) AS ViTriText,
            LISTAGG(ts.TenLoaiThuySan || ': ' || dbts.KhoiLuong || 'kg', ', ') 
                WITHIN GROUP (ORDER BY ts.TenLoaiThuySan ASC) AS ChiTietMeCa
        FROM ME_CA mc
        JOIN DANHBAT_THUYSAN dbts ON dbts.MaMeCa = mc.MaMeCa AND dbts.MaChuyenDanhBat = mc.MaChuyenDanhBat
        JOIN THUY_SAN ts ON ts.MaThuySan = dbts.MaThuySan
        WHERE mc.MaChuyenDanhBat = p_MaChuyenDanhBat
        GROUP BY             
            mc.MaMeCa, 
            mc.KhoiLuongMeCa, 
            mc.ThoiGianThaLuoi, 
            mc.ThoiGianKeoLuoi, 
            DBMS_LOB.SUBSTR(SDO_UTIL.TO_WKTGEOMETRY(mc.ViTriKeoLuoi), 4000, 1);
END;
/

-- TRUY XUAT NGUON GOC THUY SAN
CREATE OR REPLACE PROCEDURE get_aquatic_origin(
    thuy_san_cursor OUT SYS_REFCURSOR,
    p_MaThuySan NVARCHAR2
)
IS
BEGIN
    OPEN thuy_san_cursor FOR
        SELECT mc.VITRIKEOLUOI,mc.THOIGIANKEOLUOI,mc.THOIGIANTHALUOI
        FROM DANHBAT_THUYSAN dbts 
        JOIN ME_CA mc on dbts.MaMeCa = mc.MaMeCa
        WHERE dbts.MaThuySan = 1;
END;
/

-- Insert VI_PHAM
CREATE OR REPLACE PROCEDURE insert_VI_PHAM(
    p_MaChuyenDanhBat   VI_PHAM.MaChuyenDanhBat%TYPE,
    p_ViTri             VI_PHAM.ViTri%TYPE,
    p_MoTa              VI_PHAM.MoTa%TYPE
)
IS
BEGIN
    INSERT INTO VI_PHAM(MaChuyenDanhBat, ViTri, MoTa)
    VALUES (p_MaChuyenDanhBat, p_ViTri, p_MoTa);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Cap nhat MoTa cua VI_PHAM
CREATE OR REPLACE PROCEDURE update_description_VI_PHAM(
    p_MaViPham          VI_PHAM.MaViPham%TYPE,
    p_MoTa              VI_PHAM.MoTa%TYPE
)
IS
BEGIN
    UPDATE VI_PHAM
    SET MoTa = p_MoTa
    WHERE MaViPham =p_MaViPham;

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

--3.NGU TRUONG

-- THEM THONG TIN NGU TRUONG
-- insert_NGU_TRUONG
CREATE OR REPLACE PROCEDURE insert_NGU_TRUONG(
    p_TenNguTruong        NGU_TRUONG.TenNguTruong%TYPE,
    p_ViTri               CLOB,
    p_SoLuongTauToiDa     NGU_TRUONG.SoLuongTauToiDa%TYPE
)
IS 
    v_ViTri SDO_GEOMETRY;
BEGIN
    BEGIN
        v_ViTri := SDO_UTIL.FROM_WKTGEOMETRY(p_ViTri);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'WKT không hợp lệ: '||SQLERRM);
    END;

    INSERT INTO NGU_TRUONG (TenNguTruong, ViTri, SoLuongTauToiDa)
        VALUES (p_TenNguTruong, v_ViTri, p_SoLuongTauToiDa);

    COMMIT;
END;
/

-- XEM THONG TIN NGU TRUONG


--4. THONG KE
-- VI_PHAM
-- Lay danh sach VI_PHAM
CREATE OR REPLACE PROCEDURE get_list_VI_PHAM(
    vi_pham_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN vi_pham_cursor FOR
        SELECT * FROM VI_PHAM;
END;
/

-- THONG KE SO LUONG VI PHAM THEO TAU
CREATE OR REPLACE PROCEDURE statistics_VI_PHAM_by_TAU_CA(
    vi_pham_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN vi_pham_cursor FOR
        SELECT tc.MaTauCa, tc.SoDangKy, count(vp.MaViPham) AS SoLuongLoiViPham
        FROM VI_PHAM vp
        JOIN CHUYEN_DANH_BAT cdb ON cdb.MaChuyenDanhBat = vp.MaChuyenDanhBat
        JOIN TAU_CA tc ON tc.MaTauCa = cdb.MaTauCa
        GROUP BY tc.MaTauCa
        ORDER BY SoLuongLoiViPham DESC;
END;
/

-- THUY SAN
-- THONG KE SAN LUONG THEO LOAI THUY SAN
CREATE OR REPLACE PROCEDURE thong_ke_san_luong_thuy_san_theo_loai(
    thuy_san_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN thuy_san_cursor FOR
        SELECT ts.MaThuySan, ts.TenLoaiThuySan, SUM(dbts.KhoiLuong) AS TongKhoiLuong
        FROM THUY_SAN ts
        JOIN DANHBAT_THUYSAN dbts ON dbts.MaThuySan = ts.MaThuySan
        GROUP BY ts.MaThuySan, ts.TenLoaiThuySan;
END;
/

-- BAO
-- THONG KE SO LUONG BAO THEO NAM
CREATE OR REPLACE PROCEDURE thong_ke_so_bao_theo_nam(
    bao_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN bao_cursor FOR
        SELECT EXTRACT(YEAR FROM lddb.ThoiGian) AS Nam,
                COUNT(DISTINCT b.MaBao) AS SoLuongBao
        FROM BAO b
        JOIN LOG_DUONG_DI_BAO lddb ON lddb.MaBao = b.MaBao
        GROUP BY EXTRACT(YEAR FROM lddb.ThoiGian)
        ORDER BY Nam;
END;
/

--5. KHI TUONG THUY VAN
-- insert THOI_TIET
CREATE OR REPLACE PROCEDURE insert_THOI_TIET(
    p_KhuVucAnhHuong  THOI_TIET.KhuVucAnhHuong%TYPE,
    p_ChiTietDuBao    THOI_TIET.ChiTietDuBao%TYPE
)
IS
BEGIN
    INSERT INTO THOI_TIET(KhuVucAnhHuong, ChiTietDuBao)
    VALUES (p_KhuVucAnhHuong, p_ChiTietDuBao);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- insert BAO
CREATE OR REPLACE PROCEDURE insert_BAO(
    p_TenBao    BAO.TenBao%TYPE
)
IS
BEGIN
    INSERT INTO BAO(TENBAO)
    VALUES (p_TenBao);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- insert LOG_DUONG_DI_BAO
CREATE OR REPLACE PROCEDURE insert_LOG_DUONG_DI_BAO(
    p_MaBao           LOG_DUONG_DI_BAO.MaBao%TYPE,
    p_ThoiGian        LOG_DUONG_DI_BAO.ThoiGian%TYPE,
    p_ViTriWKT        VARCHAR2,
    p_MucDo           LOG_DUONG_DI_BAO.MucDo%TYPE
)
IS
    v_ViTri SDO_GEOMETRY;
BEGIN
    BEGIN
        v_ViTri := SDO_UTIL.FROM_WKTGEOMETRY(p_ViTriWKT);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'WKT không hợp lệ: '||SQLERRM);
    END;
    
    INSERT INTO LOG_DUONG_DI_BAO(
        MaBao,
        ThoiGian,
        ViTri,
        MucDo
    )
    VALUES (
        p_MaBao,
        p_ThoiGian,
        v_ViTri,
        p_MucDo
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- VI. CREATE FUNCTION
--  Kiem tra dang nhap
 CREATE OR REPLACE FUNCTION Fn_dang_nhap (
    p_username      APP_USER.USERNAME%TYPE,
    p_password      APP_USER.PASSWORD%TYPE
) RETURN NVARCHAR2
IS
    f_user_id NVARCHAR2(20);
BEGIN
    SELECT USER_ID
    INTO f_user_id
    FROM APP_USER
    WHERE USERNAME = p_username
      AND PASSWORD = p_password;

    RETURN USER_ID;

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

--Kiem tra dang ky
CREATE OR REPLACE FUNCTION Fn_kiem_tra_username_ton_tai(
    p_username NVARCHAR2
) RETURN BOOLEAN
IS
    f_count INTEGER;
BEGIN
    SELECT COUNT(*) 
    INTO f_count
    FROM APP_USER
    WHERE USERNAME = p_username;

    RETURN f_count > 0;
END;
/

--Kiem tra cccd ton tai
CREATE OR REPLACE FUNCTION Fn_kiem_tra_cccd_ton_tai (
    p_cccd NVARCHAR2
) RETURN BOOLEAN
IS
    f_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO f_count
    FROM CHU_TAU
    WHERE CCCD = p_cccd;

    RETURN f_count > 0;
END;
/

-- Kiem tra so luong tau hien tai
CREATE OR REPLACE FUNCTION Fn_kiem_tra_so_luong_tau (
    p_MaNguTruong      NGU_TRUONG.MaNguTruong%TYPE
) RETURN BOOLEAN
IS
    f_HienTai       NGU_TRUONG.SoLuongTauHienTai%TYPE;
    f_ToiDa         NGU_TRUONG.SoLuongTauToiDa%TYPE;
BEGIN
    SELECT SoLuongTauHienTai, SoLuongTauToiDa
    INTO f_HienTai, f_ToiDa
    FROM NGU_TRUONG
    WHERE MaNguTruong = p_MaNguTruong;

    RETURN f_HienTai < f_ToiDa;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE; 
END;
/

--Kiem tra user co phai admin khong
CREATE OR REPLACE FUNCTION Fn_la_admin (
    p_user_id NVARCHAR2
) RETURN BOOLEAN
IS
    f_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO f_count
    FROM ADMIN
    WHERE MaAdmin = p_user_id;

    RETURN f_count > 0;
END;
/

--Kiem tra tau co hoat dong khong
CREATE OR REPLACE FUNCTION Fn_tau_dang_hoat_dong (
    p_MaTauCa NVARCHAR2
) RETURN BOOLEAN
IS
    f_trangthai NVARCHAR2(20);
BEGIN
    SELECT TrangThaiHoatDong INTO f_trangthai
    FROM TAU_CA
    WHERE MaTauCa = p_MaTauCa;

    RETURN f_trangthai = 'DANG HOAT DONG';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
/

--Dem so chuyen danh bat cua mot tau
CREATE OR REPLACE FUNCTION Fn_dem_chuyen_danh_bat (
    p_MaTauCa NVARCHAR2
) RETURN INTEGER
IS
    f_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO f_count
    FROM CHUYEN_DANH_BAT
    WHERE MaTauCa = p_MaTauCa;

    RETURN f_count;
END;
/


-- VII. TEST CASE

--Lay danh sach tau cua chu tau
VAR c REFCURSOR;
EXEC Hien_thi_danh_sach_tau_ca_cua_chu_tau(:c, 'USER01');
PRINT c;