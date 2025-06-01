-- IV. CREATE TRIGGER

-- V. CREATE PROCEDURE
-- Tao admin
CREATE OR REPLACE PROCEDURE INSERT_ADMIN_MOI(
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
-- Tao chu tau
CREATE OR REPLACE PROCEDURE INSERT_CHU_TAU_MOI(
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
-- Them NGHE moi
CREATE OR REPLACE PROCEDURE INSERT_TAU_NGHE(
    p_MaNghe        NGHE.MaNghe%TYPE,
    p_TenNghe       NGHE.TenNghe%TYPE
)
IS
BEGIN
    INSERT INTO NGHE(MaNghe, TenNghe)
    VALUES (p_MaNghe, p_TenNghe);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;

-- Lay danh sach TAU_CA cua CHU_TAU
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_ca_cua_chu_tau(
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

-- Tao TAU_CA
CREATE OR REPLACE PROCEDURE INSERT_TAU_CA(
    p_SoDangKy           TAU_CA.SoDangKy%TYPE,
    p_LoaiTau            TAU_CA.LoaiTau%TYPE,
    p_ChieuDai           TAU_CA.ChieuDai%TYPE,
    p_CongSuat           TAU_CA.CongSuat%TYPE,
    p_NamDongTau         TAU_CA.NamDongTau%TYPE,
    p_MaChuTau           TAU_CA.MaChuTau%TYPE,
    p_MaNgheChinh        TAU_CA.MaNgheChinh%TYPE
)
IS
BEGIN
    INSERT INTO TAU_CA(SoDangKy, LoaiTau, ChieuDai, CongSuat, NamDongTau, MaChuTau, MaNgheChinh)
    VALUES (p_SoDangKy, p_LoaiTau, p_ChieuDai, p_CongSuat, p_NamDongTau, p_MaChuTau, p_MaNgheChinh);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Them NGHE cho TAU_CA
CREATE OR REPLACE PROCEDURE INSERT_TAU_NGHE(
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

-- DUYET THONG TIN CHU_TAU
-- Lay danh sach CHU_TAU
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_chu_tau(
    chu_tau_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN chu_tau_cursor FOR
        SELECT * FROM CHU_TAU ct
        WHERE ct.TrangThaiDuyet = 'DANG CHO';
END;
/

-- Cap nhat trang thai duyet CHU_TAU
CREATE OR REPLACE PROCEDURE UPDATE_STATUS_CHU_TAU(
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
-- Lay danh sach TAU_CA
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_ca (
    p_cursor OUT SYS_REFCURSOR
) 
IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM TAU_CA tc
        WHERE tc.TrangThaiDuyet = 'DANG CHO';
END;
/

-- Cap nhat trang thai duyet TAU_CA
CREATE OR REPLACE PROCEDURE UPDATE_STATUS_TAU_CA(
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
CREATE OR REPLACE PROCEDURE UPDATE_CHU_TAU(
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
CREATE OR REPLACE PROCEDURE UPDATE_TAU_CA(
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
CREATE OR REPLACE PROCEDURE get_status_CHU_TAU(
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
CREATE OR REPLACE PROCEDURE get_status_TAU_CA(
    tau_ca_cursor OUT SYS_REFCURSOR,
    p_MaChuTau        CHU_TAU.MaChuTau%TYPE
)
IS
BEGIN
    OPEN tau_ca_cursor FOR
        SELECT tc.MaTauCa, tc.TrangThaiDuyet
        FROM TAU_CA tc
        WHERE tc.MaChuTau = p_MaChuTau;
END;
/

-- 2.HOAT DONG DANH BAT BAT

-- DANG KY THONG TIN CHUYEN DANH BAT
-- Lay danh sach TAU_CA va trang thai hoat dong TAU_CA
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_va_trang_thai_hoat_dong_cua_tau_ca(
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

-- Tao CHUYEN_DANH_BAT
CREATE OR REPLACE PROCEDURE INSERT_CHUYEN_DANH_BAT_MOI(
    p_MaTauCa             CHUYEN_DANH_BAT.MaTauCa%TYPE,
    p_MaNguTruong         CHUYEN_DANH_BAT.MaNguTruong%TYPE
)
IS
    p_TrangThaiDuyetChuTau    CHU_TAU.TrangThaiDuyet%TYPE;
    p_TrangThaiDuyetTauCa     TAU_CA.TrangThaiDuyet%TYPE;
    p_TrangThaiHoatDongTauCa     TAU_CA.TrangThaiDuyet%TYPE;
BEGIN
    SELECT ct.TrangThaiDuyet, tc.TrangThaiDuyet, tc.TrangThaiHoatDong
    INTO p_TrangThaiDuyetChuTau, p_TrangThaiDuyetTauCa, p_TrangThaiHoatDongTauCa
    FROM TAU_CA tc JOIN CHU_TAU ct ON tc.MaChuTau = ct.MACHUTAU
    WHERE tc.MaTauCa = p_MaTauCa;

    IF p_TrangThaiDuyetChuTau = 'DA DUYET' AND p_TrangThaiDuyetTauCa = 'DA DUYET' AND p_TrangThaiHoatDongTauCa = 'DANG CHO|CHUA DK' THEN
        INSERT INTO CHUYEN_DANH_BAT(
            MaTauCa,
            MaNguTruong
        )
        VALUES(
            p_MaTauCa,
            p_MaNguTruong
        );
    ELSIF p_TrangThaiHoatDongTauCa != 'DANG CHO|CHUA DK' THEN
        RAISE_APPLICATION_ERROR(-20001, 'TAU DA DUOC DANG KY');
    ELSE
        RAISE_APPLICATION_ERROR(-20002, 'HO SO CHU TAU HOAC HO SO TAU CA CHUA DUOC DUYET');
    END IF;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

-- Cap nhat trang thai CHUYEN_DANH_BAT ?? CHUA HIEU DOAN NAY DE LAM GI
CREATE OR REPLACE PROCEDURE UPDATE_STATUS_CHUYEN_DANH_BAT(
    p_TrangThaiDuyet    CHUYEN_DANH_BAT.TrangThaiDuyet%TYPE,
    p_MaChuyenDanhBat   CHUYEN_DANH_BAT.MaChuyenDanhBat%TYPE
)
IS
BEGIN
    IF p_trangthaiduyet = 'DA DUYET' THEN
        UPDATE CHUYEN_DANH_BAT
        SET TRANGTHAIDUYET = p_trangthaiduyet
        WHERE MACHUYENDANHBAT = p_MaChuyenDanhBat;
    ELSE
        UPDATE CHUYEN_DANH_BAT
        SET TRANGTHAIDUYET = p_trangthaiduyet, TRANGTHAIHOATDONG = 'DANG CHO|DA DK'
        WHERE MACHUYENDANHBAT = p_MaChuyenDanhBat;
    END IF;
END;
/

-- CAP NHAT TRANG THAI ROI / CAP CANG
-- Lay danh sach CHUYEN_DANH_BAT cua TAU_CA
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_chuyen_danh_bat_cua_tau(
    tau_ca_cursor OUT SYS_REFCURSOR,
    p_MaTauCa         CHUYEN_DANH_BAT.MaTauCa%TYPE
)
IS
BEGIN
    OPEN tau_ca_cursor FOR
        SELECT * 
        FROM CHUYEN_DANH_BAT cdb 
        WHERE cdb.MaTauCa = p_MaTauCa;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/

-- Cap nhat trang thai roi cang
CREATE OR REPLACE PROCEDURE cap_nhat_trang_thai_roi_cang(
    p_MaTauCa CHUYEN_DANH_BAT.MaTauCa%TYPE
)
IS
BEGIN
    UPDATE TAU_CA
    SET TrangThaiHoatDong = 'DANG HOAT DONG'
    WHERE MaTauCa = p_MaTauCa;
END;
/

-- Cap nhat trang thai cap cang
CREATE OR REPLACE PROCEDURE cap_nhat_trang_thai_cap_cang(
    p_MaTauCa CHUYEN_DANH_BAT.MaTauCa%TYPE
)
IS
BEGIN
    UPDATE TAU_CA
    SET TrangThaiHoatDong = 'DANG CHO|CHUA DK'
    WHERE MaTauCa = p_MaTauCa;
END;
/


CREATE OR REPLACE PROCEDURE truy_xuat_nguon_goc_hai_san(
    thuy_san_cursor OUT SYS_REFCURSOR,
    p_MaThuySan NVARCHAR2
)
IS
BEGIN
    OPEN thuy_san_cursor FOR
        SELECT mc.VITRIKEOLUOI,mc.THOIGIANKEOLUOI,mc.THOIGIANTHALUOI
        FROM DANHBAT_THUYSAN dbts 
        JOIN ME_CA mc on dbts.MaMeCa = mc.MaMeCa
        WHERE dbts.MaThuySan = p_MaThuySan;
END;
/
--Truy xuat nhat ky danh bat
--khong hieu nghe ra sao ???
CREATE OR REPLACE PROCEDURE truy_xuat_nhat_ky_danh_bat(
    nhat_ky_cursor OUT SYS_REFCURSOR,
    p_MaTauCa NVARCHAR2 
)
IS
BEGIN
    OPEN nhat_ky_cursor FOR 
        SELECT 
            ct.HoTen,
            tc.MaTauCa, tc.SoDangKy, tc.LoaiTau, tc.ChieuDai, tc.CongSuat,
            cdb.MaChuyenDanhBat, cdb.NgayCapBen, cdb.NgayXuatBen, cdb.CangDi, cdb.CangVe,
            ng.TenNghe
        FROM TAU_CA tc
        JOIN CHU_TAU ct ON tc.MaChuTau = ct.MaChuTau
        JOIN CHUYEN_DANH_BAT cdb ON tc.MaTauCa = cdb.MaTauCa
        LEFT JOIN TAU_NGHE t_n ON t_n.MaTauCa = tc.MaTauCa
        LEFT JOIN NGHE ng ON t_n.MaNghe = ng.MaNghe
        WHERE tc.MaTauCa = p_MaTauCa;
END;
/

CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_ca_dang_hoat_dong_cua_chu_tau(
    p_cursor OUT SYS_REFCURSOR,
    p_MaChuTau  NVARCHAR2
    
)
IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM TAU_CA t WHERE t.MaChuTau = p_MaChuTau AND t.TRANGTHAIHOATDONG ='DANG HOAT DONG';

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
/
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_ca_dang_hoat_dong(
    
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


--3.NGU TRUONG
CREATE OR REPLACE PROCEDURE cap_nhat_thong_tin_ngu_truong(
    p_MaNguTruong         NVARCHAR2,
    p_TenNguTruong        NVARCHAR2,
    p_XY_DS               SYS.ODCINUMBERLIST,
    p_SRID                NUMBER,
    p_SoLuongTauHienTai   INTEGER,
    p_SoLuongTauToiDa     INTEGER
)
IS 
    v_ViTri SDO_GEOMETRY;
    v_Count INTEGER;
BEGIN
    v_ViTri := SDO_GEOMETRY(
        2003, -- Geometry type (2003 for 2D) 
        NULL, --he quy chieu khong gian 
        NULL, --sdo_point--dung cho diem don lele
        SDO_ELEM_INFO_ARRAY(1, 1003, 1),--(mang thong tin cau tructruc) 1 vi tri bat dau, 1003 la polygon vong ngoai,1 noi cac dinh bang duong htanghtang
        SDO_ORDINATE_ARRAY()  --khai bao mang rong 
    );
    --Kiem tra so luong toa do hop le
    v_Count := p_XY_DS.COUNT;
    IF MOD(v_Count, 2) != 0 THEN
    RAISE_APPLICATION_ERROR(-20002,'Danh sach toa do khong hop le');
    END IF;

    --Kiem tra toa do dau va cuoi cung co trung nhau khongkhong
    IF (p_XY_DS(1)    != p_XY_DS(v_Count - 1)) OR
       (p_XY_DS(2)    != p_XY_DS(v_Count    )) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Polygon khong khep kin: diem dau va diem cuoi phai trung nhau.');
    END IF;

    --Gan toa do vao v_ViTri
    v_ViTri.SDO_ORDINATES := p_XY_DS;
    --Gan SRID vao v_ViTri
    v_ViTri.SDO_SRID := p_SRID;
    --Update thong tin ngu truong
    UPDATE NGU_TRUONG
    SET TenNguTruong = p_TenNguTruong,ViTri=v_ViTri,SoLuongTauHienTai = p_SoLuongTauHienTai,SoLuongTauToiDa = p_SoLuongTauToiDa
    WHERE MANGUTRUONG = p_MaNguTruong;

    EXCEPTION
    WHEN OTHERS THEN
        -- In thông báo lỗi ra màn hình, rồi kết thúc thủ tục
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RETURN;
END;
/
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_cac_ngu_truong(
    ngu_truong_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN ngu_truong_cursor FOR
        SELECT ng.MANGUTRUONG,ng.TENNGUTRUONG FROM NGU_TRUONG ng;
END;
/

CREATE OR REPLACE PROCEDURE Hien_thi_ngu_truong(
    ngu_truong_cursor OUT SYS_REFCURSOR,
    p_MaNguTruong NVARCHAR2
)
IS
BEGIN
    OPEN ngu_truong_cursor FOR
        SELECT* FROM NGU_TRUONG ng WHERE ng.MANGUTRUONG = p_MaNguTruong; 

END;
/

--4.THONG KE

--Vi pham
CREATE OR REPLACE PROCEDURE hien_thi_danh_sach_vi_pham(
    vi_pham_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN vi_pham_cursor FOR
        SELECT * FROM VI_PHAM;
END;
/

CREATE OR REPLACE PROCEDURE thong_ke_so_luong_vi_pham_chuyendb(
    vi_pham_cursor OUT SYS_REFCURSOR,
    p_MaChuyenDanhBat NVARCHAR2
)
IS
BEGIN
    OPEN vi_pham_cursor FOR
        SELECT * FROM VI_PHAM vp
        Where vp.MaChuyenDanhBat = p_MaChuyenDanhBat;
END;
/

CREATE OR REPLACE PROCEDURE thong_ke_so_luong_vi_pham_maVP(
    vi_pham_cursor OUT SYS_REFCURSOR,
    p_MaViPham NVARCHAR2
)
IS
BEGIN
    OPEN vi_pham_cursor FOR
        SELECT * FROM VI_PHAM vp
        Where vp.MAVIPHAM = p_MaViPham;
END;
/

--Bao

CREATE OR REPLACE PROCEDURE hien_thi_danh_sach_bao(
    bao_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN bao_cursor FOR
        SELECT * FROM BAO;
END;

CREATE OR REPLACE PROCEDURE thong_tin_chi_tiet_Bao(
    bao_cursor OUT SYS_REFCURSOR,
    p_MaBao NVARCHAR2
)
IS
BEGIN
    OPEN bao_cursor FOR
        SELECT * FROM LOG_DUONG_DI_BAO b
        WHERE b.MABAO = p_MaBao;
END;

--Thuy san
CREATE OR REPLACE PROCEDURE thong_ke_so_luong_thuy_san(
    thuy_san_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN thuy_san_cursor FOR
        SELECT * FROM THUY_SAN;
END;
/

CREATE OR REPLACE PROCEDURE thong_ke_so_luong_thuy_san_theo_loai(
    thuy_san_cursor OUT SYS_REFCURSOR,
    p_TenLoaiThuySan NVARCHAR2
)
IS
BEGIN
    OPEN thuy_san_cursor FOR
        SELECT * FROM THUY_SAN ts
        WHERE ts.TenLoaiThuySan = p_TenLoaiThuySan;
END;

CREATE OR REPLACE PROCEDURE thong_ke_so_luong_thuy_san_theo_ma(
    thuy_san_cursor OUT SYS_REFCURSOR,
    p_MaThuySan NVARCHAR2
)
IS
BEGIN
    OPEN thuy_san_cursor FOR
        SELECT * FROM THUY_SAN ts
        WHERE ts.MaThuySan = p_MaThuySan;
END;
-- VI. CREATE FUNCTION

 --Kiem tra dang nhap
 CREATE OR REPLACE FUNCTION Fn_dang_nhap (
    p_username NVARCHAR2,
    p_password NVARCHAR2
) RETURN NVARCHAR2
IS
    f_user_id NVARCHAR2(20);
BEGIN
    SELECT USER_ID
    INTO f_user_id
    FROM APP_USER
    WHERE USERNAME = p_username
      AND PASSWORD = p_password;

    RETURN f_user_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/
--Kiem tra dang ky
CREATE OR REPLACE FUNCTION Fn_kiem_tra_username_ton_tai (
    p_username NVARCHAR2
) RETURN BOOLEAN
IS
    f_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO f_count
    FROM APP_USER
    WHERE USERNAME = p_username;

    RETURN f_count > 0;
END;
/
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

--Dang ky chuyen danh bat moi
CREATE OR REPLACE FUNCTION Fn_kiem_tra_so_luong_tau (
    p_MaNguTruong NVARCHAR2
) RETURN BOOLEAN
IS
    f_HienTai INTEGER;
    f_ToiDa INTEGER;
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
CREATE OR REPLACE FUNCTION Fn_tao_chuyen_danh_bat (
    p_NgayXuatBen     DATE,
    p_NgayCapBen      DATE,
    p_CangDi          NVARCHAR2,
    p_CangVe          NVARCHAR2,
    p_MaTauCa         NVARCHAR2,
    p_MaNguTruong     NVARCHAR2
) RETURN NVARCHAR2
IS
    f_MaChuyenDanhBat NVARCHAR2(20);
BEGIN
	SELECT 'CDP' || SEQ_CHUYEN_DANH_BAT.NEXTVAL
    INTO f_MaChuyenDanhBat
    FROM DUAL;

    INSERT INTO CHUYEN_DANH_BAT (
        MaChuyenDanhBat, NgayXuatBen, NgayCapBen,
        CangDi, CangVe, MaTauCa, MaNguTruong
    ) VALUES (
        f_MaChuyenDanhBat, p_NgayXuatBen, p_NgayCapBen,
        NULLIF(p_CangDi, ''), NULLIF(p_CangVe, ''),
        p_MaTauCa, p_MaNguTruong
    );

    RETURN f_MaChuyenDanhBat;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL; 
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