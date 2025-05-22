-- I. CREATE TABLE
-- 1. Bang USER
CREATE TABLE APP_USER (
    USER_ID        NVARCHAR2(20)   PRIMARY KEY,
    USERNAME       NVARCHAR2(50)   NOT NULL UNIQUE,
    PASSWORD       NVARCHAR2(100)  NOT NULL,
    ROLE           NVARCHAR2(20)   DEFAULT 'CHUTAU'
);

-- 2. Bang ADMIN
CREATE TABLE ADMIN (
    MaAdmin        NVARCHAR2(20)    PRIMARY KEY,
    HoTen          NVARCHAR2(100)   NOT NULL,
    CoQuan         NVARCHAR2(100)   NOT NULL,
    CCCD           NVARCHAR2(20)    NOT NULL UNIQUE
);

-- 3. Bang CHU_TAU
CREATE TABLE CHU_TAU (
    MaChuTau        NVARCHAR2(20)   PRIMARY KEY,
    HoTen           NVARCHAR2(50)   NOT NULL,
    SDT             NVARCHAR2(20)   NOT NULL,
    DiaChi          NVARCHAR2(100),
    CCCD            NVARCHAR2(20)   NOT NULL UNIQUE,
    TrangThaiDuyet  NVARCHAR2(50)   DEFAULT 'DANG CHO'
);

-- 4. Bang TAU_CA
CREATE TABLE TAU_CA (
    MaTauCa            NVARCHAR2(20) PRIMARY KEY,
    SoDangKy           NVARCHAR2(50) UNIQUE,
    LoaiTau            NVARCHAR2(50),
    ChieuDai           NUMBER(10,2),
    CongSuat           NUMBER(10,2),
    NamDongTau         INTEGER,
    TrangThaiDuyet     NVARCHAR2(20) DEFAULT 'DANG CHO',
    TrangThaiHoatDong  NVARCHAR2(20) DEFAULT 'DANG CHO|CHUA DK',
    MaChuTau           NVARCHAR2(20) NOT NULL,
    MaNgheChinh        NVARCHAR2(20) NOT NULL
);


-- 5. Bang NGHE
CREATE TABLE NGHE (
    MaNghe        NVARCHAR2(20) PRIMARY KEY,
    TenNghe       NVARCHAR2(100) NOT NULL UNIQUE
);

-- 6. BANG TAU_NGHE
CREATE TABLE TAU_NGHE (
    MaTauCa       NVARCHAR2(20),
    MaNghe        NVARCHAR2(20),
    VungHoatDong  NVARCHAR2(100) NOT NULL,
    PRIMARY KEY (MaTauCa, MaNghe)
);

-- 7. Bang VI_PHAM
CREATE TABLE VI_PHAM (
    MaViPham            NVARCHAR2(20)   PRIMARY KEY,
    ThoiGian            DATE            NOT NULL,
    ViTri               SDO_GEOMETRY    NOT NULL,
    MoTa                NVARCHAR2(400)  NOT NULL,
    MaChuyenDanhBat     NVARCHAR2(20)   NOT NULL
);

-- 8. Bang LOG_HAI_TRINH
CREATE TABLE LOG_HAI_TRINH (
    MaLogHaiTrinh       INTEGER,
    MaChuyenDanhBat     NVARCHAR2(20),
    ThoiGian            DATE            NOT NULL,
    ViTri               SDO_GEOMETRY    NOT NULL,
    VanToc              NUMBER(10,2),
    HuongDiChuyen       NVARCHAR2(100),
    PRIMARY KEY (MaLogHaiTrinh, MaChuyenDanhBat)
);

-- 9. Bang CHUYEN_DANH_BAT
CREATE TABLE CHUYEN_DANH_BAT (
    MaChuyenDanhBat     NVARCHAR2(20) PRIMARY KEY,
    NgayXuatBen         DATE,
    NgayCapBen          DATE,
    CangDi              NVARCHAR2(100),
    CangVe              NVARCHAR2(100),
    TongKhoiLuong       NUMBER(12,2) DEFAULT 0,
    TrangThaiDuyet      NVARCHAR2(20) DEFAULT 'DANG CHO',
    TrangThaiHoatDong   NVARCHAR2(20) DEFAULT 'DANG CHO',
    MaTauCa             NVARCHAR2(20) NOT NULL,
    MaNguTruong         NVARCHAR2(20) NOT NULL
);

-- 10. Bang ME_CA
CREATE TABLE ME_CA (
    MaMeCa              INTEGER,
    MaChuyenDanhBat     NVARCHAR2(20),
    KhoiLuongMeCa       NUMBER(12,2) DEFAULT 0,
    ThoiGianThaLuoi     DATE,
    ThoiGianKeoLuoi     DATE,
    ViTriKeoLuoi        SDO_GEOMETRY NOT NULL,
    PRIMARY KEY (MaMeCa, MaChuyenDanhBat)
);

-- 11. BANG DANHBAT_THUYSAN
CREATE TABLE DANHBAT_THUYSAN (
    MaThuySan           NVARCHAR2(20),
    MaMeCa              INTEGER,
    MaChuyenDanhBat     NVARCHAR2(20),
    KhoiLuong           NUMBER NOT NULL,
    PRIMARY KEY (MaThuySan, MaMeCa, MaChuyenDanhBat)
);

-- 12. Bang THUY_SAN
CREATE TABLE THUY_SAN (
    MaThuySan           NVARCHAR2(20) PRIMARY KEY,
    TenLoaiThuySan      NVARCHAR2(100) UNIQUE
);

-- 13. Bang NGU_TRUONG
CREATE TABLE NGU_TRUONG (
    MaNguTruong         NVARCHAR2(20) PRIMARY KEY,
    TenNguTruong        NVARCHAR2(100) UNIQUE,
    ViTri               SDO_GEOMETRY NOT NULL,
    SoLuongTauHienTai   INTEGER DEFAULT 0,
    SoLuongTauToiDa     INTEGER NOT NULL
);

-- 14. Bang THOI_TIET
CREATE TABLE THOI_TIET (
    MaDuBao         NVARCHAR2(20) PRIMARY KEY,
    ThoiGianDuBao   DATE            NOT NULL,
    KhuVucAnhHuong  NVARCHAR2(100)  NOT NULL,
    ChiTietDuBao    NVARCHAR2(400)  NOT NULL
);

-- 15. Bang BAO
CREATE TABLE BAO (
    MaBao   NVARCHAR2(20)   PRIMARY KEY,
    TenBao  NVARCHAR2(100)  NOT NULL UNIQUE
);

-- 16. Bang LOG_DUONG_DI_BAO
CREATE TABLE LOG_DUONG_DI_BAO (
    MaLogDuongDi    INTEGER,
    MaBao           NVARCHAR2(20),
    ThoiGian        DATE            NOT NULL,
    ViTri           SDO_GEOMETRY    NOT NULL,
    MucDo           NUMBER(20),
    PRIMARY KEY (MaLogDuongDi, MaBao)
);

-- II. CREATE SEQUENCE
-- 1. FOR APP_USER
CREATE SEQUENCE SEQ_APP_USER
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_USER_ID
BEFORE INSERT ON APP_USER
FOR EACH ROW
BEGIN
  :NEW.USER_ID := 'USER' || SEQ_APP_USER.NEXTVAL;
END;

-- 2. FOR TAU_CA
CREATE SEQUENCE SEQ_TAU_CA
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_MaTauCa
BEFORE INSERT ON TAU_CA
FOR EACH ROW
BEGIN
  :NEW.MaTauCa := 'TC' || SEQ_TAU_CA.NEXTVAL;
END;

-- 3. FOR NGHE
CREATE SEQUENCE SEQ_NGHE
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_NGHE
BEFORE INSERT ON NGHE
FOR EACH ROW
BEGIN
  :NEW.MaNghe := 'NGHE' || SEQ_NGHE.NEXTVAL;
END;

-- 4. FOR VI_PHAM
CREATE SEQUENCE SEQ_VI_PHAM
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_VI_PHAM
BEFORE INSERT ON VI_PHAM
FOR EACH ROW
BEGIN
  :NEW.MaViPham := 'VP' || SEQ_VI_PHAM.NEXTVAL;
END;

-- 5. FOR CHUYEN_DANH_BAT
CREATE SEQUENCE SEQ_CHUYEN_DANH_BAT
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_CHUYEN_DANH_BAT
BEFORE INSERT ON CHUYEN_DANH_BAT
FOR EACH ROW
BEGIN
  :NEW.MaChuyenDanhBat := 'CDP' || SEQ_CHUYEN_DANH_BAT.NEXTVAL;
END;

-- 6. FOR THUY_SAN
CREATE SEQUENCE SEQ_THUY_SAN
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_THUY_SAN
BEFORE INSERT ON THUY_SAN
FOR EACH ROW
BEGIN
  :NEW.MaThuySan := 'TS' || SEQ_THUY_SAN.NEXTVAL;
END;

-- 7. FOR NGU_TRUONG
CREATE SEQUENCE NGU_TRUONG
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_NGU_TRUONG
BEFORE INSERT ON NGU_TRUONG
FOR EACH ROW
BEGIN
  :NEW.MaNguTruong := 'NT' || SEQ_NGU_TRUONG.NEXTVAL;
END;

-- 8. FOR THOI_TIET
CREATE SEQUENCE THOI_TIET
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_THOI_TIET
BEFORE INSERT ON THOI_TIET
FOR EACH ROW
BEGIN
  :NEW.MaDuBao := 'DB' || SEQ_THOI_TIET.NEXTVAL;
END;

-- 9. FOR BAO
CREATE SEQUENCE BAO
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER TRG_CREATE_BAO
BEFORE INSERT ON BAO
FOR EACH ROW
BEGIN
  :NEW.MaBao := 'BAO' || SEQ_BAO.NEXTVAL;
END;

-- 10. FOR LOG_HAI_TRINH
CREATE OR REPLACE TRIGGER TRG_CREATE_SEQ_LOG_HAI_TRINH
BEFORE INSERT ON LOG_HAI_TRINH
FOR EACH ROW
DECLARE
    max_stt INTEGER;
BEGIN
    SELECT NVL(MAX(MaLogHaiTrinh), 0)
    INTO max_stt
    FROM LOG_HAI_TRINH
    WHERE MaChuyenDanhBat = :NEW.MaChuyenDanhBat;

    :NEW.MaLogHaiTrinh := max_stt + 1;
END;

-- 11. FOR LOG_DUONG_DI_BAO
CREATE OR REPLACE TRIGGER TRG_CREATE_SEQ_LOG_DUONG_DI_BAO
BEFORE INSERT ON LOG_DUONG_DI_BAO
FOR EACH ROW
DECLARE
    max_stt INTEGER;
BEGIN
    SELECT NVL(MAX(MaLogDuongDi), 0)
    INTO max_stt
    FROM LOG_DUONG_DI_BAO
    WHERE MaBao = :NEW.MaBao;

    :NEW.MaLogDuongDi := max_stt + 1;
END;

-- 12. FOR ME_CA
CREATE OR REPLACE TRIGGER TRG_CREATE_SEQ_ME_CA
BEFORE INSERT ON ME_CA
FOR EACH ROW
DECLARE
    max_stt INTEGER;
BEGIN
    SELECT NVL(MAX(MaMeCa), 0)
    INTO max_stt
    FROM ME_CA
    WHERE MaChuyenDanhBat = :NEW.MaChuyenDanhBat;

    :NEW.MaMeCa := max_stt + 1;
END;

-- III. CREATE CONSTRAINT
-- i. CHECK
ALTER TABLE APP_USER ADD CONSTRAINT CK_APP_USER_1 CHECK (ROLE IN ('ADMIN', 'CHUTAU'));

ALTER TABLE CHU_TAU ADD CONSTRAINT CK_CHU_TAU_1 CHECK (TrangThaiDuyet IN ('DANG CHO', 'DA DUYET', 'TU CHOI'));

ALTER TABLE TAU_CA ADD CONSTRAINT CK_TAU_CA_1 CHECK (TrangThaiDuyet IN ('DANG CHO', 'DA DUYET', 'TU CHOI'));
ALTER TABLE TAU_CA ADD CONSTRAINT CK_TAU_CA_2 CHECK (TrangThaiHoatDong IN ('DANG CHO|CHUA DK', 'DANG CHO|DA DK', 'DANG HOAT DONG'));

ALTER TABLE CHUYEN_DANH_BAT ADD CONSTRAINT CK_CHUYEN_DANH_BAT_1 CHECK (TrangThaiDuyet IN ('DANG CHO', 'DA DUYET', 'TU CHOI'));
ALTER TABLE CHUYEN_DANH_BAT ADD CONSTRAINT CK_CHUYEN_DANH_BAT_2 CHECK (TrangThaiHoatDong IN ('DANG CHO', 'DANG DAN BAT', 'HOAN THANH'));

ALTER TABLE LOG_DUONG_DI_BAO ADD CONSTRAINT CK_LOG_DUONG_DI_BAO_1 CHECK (Mucdo IN (1,2,3,4,5));

-- ii. FOREIGN KEY
ALTER TABLE ADMIN ADD CONSTRAINT FK_ADMIN_1 FOREIGN KEY (MaAdmin) REFERENCES APP_USER(USER_ID);

ALTER TABLE CHU_TAU ADD CONSTRAINT FK_CHU_TAU_1 FOREIGN KEY (MaChuTau) REFERENCES APP_USER(USER_ID);

ALTER TABLE TAU_CA ADD CONSTRAINT FK_TAU_CA_1 FOREIGN KEY (MaChuTau) REFERENCES CHU_TAU(MaChuTau);
ALTER TABLE TAU_CA ADD CONSTRAINT FK_TAU_CA_2 FOREIGN KEY (MaNgheChinh) REFERENCES NGHE(MaNghe);

ALTER TABLE TAU_NGHE ADD CONSTRAINT FK_TAU_NGHE_1 FOREIGN KEY (MaTauCa) REFERENCES TAU_CA(MaTauCa);
ALTER TABLE TAU_NGHE ADD CONSTRAINT FK_TAU_NGHE_2 FOREIGN KEY (MaNghe) REFERENCES NGHE(MaNghe);

ALTER TABLE VI_PHAM ADD CONSTRAINT FK_VI_PHAM_1 FOREIGN KEY (MaChuyenDanhBat) REFERENCES CHUYEN_DANH_BAT(MaChuyenDanhBat);

ALTER TABLE LOG_HAI_TRINH ADD CONSTRAINT FK_LOG_HAI_TRINH_1 FOREIGN KEY (MaChuyenDanhBat) REFERENCES CHUYEN_DANH_BAT(MaChuyenDanhBat);

ALTER TABLE CHUYEN_DANH_BAT ADD CONSTRAINT FK_CHUYEN_DANH_BAT_1 FOREIGN KEY (MaTauCa) REFERENCES TAU_CA(MaTauCa);
ALTER TABLE CHUYEN_DANH_BAT ADD CONSTRAINT FK_CHUYEN_DANH_BAT_2 FOREIGN KEY (MaNguTruong) REFERENCES NGU_TRUONG(MaNguTruong);

ALTER TABLE ME_CA ADD CONSTRAINT FK_ME_CA_1 FOREIGN KEY (MaChuyenDanhBat) REFERENCES CHUYEN_DANH_BAT(MaChuyenDanhBat);

ALTER TABLE DANHBAT_THUYSAN ADD CONSTRAINT FK_DANHBAT_THUYSAN_1 FOREIGN KEY (MaThuySan) REFERENCES THUY_SAN(MaThuySan);
ALTER TABLE DANHBAT_THUYSAN ADD CONSTRAINT FK_DANHBAT_THUYSAN_2 FOREIGN KEY (MaMeCa) REFERENCES ME_CA(MaMeCa);
ALTER TABLE DANHBAT_THUYSAN ADD CONSTRAINT FK_DANHBAT_THUYSAN_3 FOREIGN KEY (MaChuyenDanhBat) REFERENCES CHUYEN_DANH_BAT(MaChuyenDanhBat);

ALTER TABLE LOG_DUONG_DI_BAO ADD CONSTRAINT FK_LOG_DUONG_DI_BAO_1 FOREIGN KEY (MaBao) REFERENCES BAO(MaBao);

-- IV. CREATE TRIGGER

-- V. CREATE PROCEDURE

--tao user moi
CREATE OR REPLACE PROCEDURE tao_chu_tau_moi(
    p_USER_ID        NVARCHAR2,
    p_USERNAME       NVARCHAR2,
    p_PASSWORD       NVARCHAR2
)
IS
BEGIN
    INSERT INTO APP_USER(USER_ID,USERNAME,PASSWORD)
    VALUES(p_USER_ID,p_USERNAME,p_PASSWORD);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    RAISE;

END;
/

CREATE OR REPLACE PROCEDURE tao_admin_moi(
    p_MaAdmin        NVARCHAR2,
    p_HoTen          NVARCHAR2,
    p_CoQuan         NVARCHAR2,
    p_CCCD           NVARCHAR2 
)
IS
BEGIN
    INSERT INTO ADMIN(MaAdmin,HoTen,CoQuan,CCCD)
    VALUES(p_MaAdmin,p_HoTen,p_CoQuan,p_CCCD);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/
--Hien thi danh sach
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_chu_tau(
    chu_tau_cursor OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN chu_tau_cursor FOR
        SELECT* FROM CHU_TAU;
END;
/
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_ca (
    p_cursor OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_cursor FOR
        SELECT * FROM TAU_CA;
END;
/
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_tau_ca_cua_chu_tau(
    p_cursor OUT SYS_REFCURSOR,
    p_MaChuTau  NVARCHAR2
    
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
CREATE OR REPLACE PROCEDURE Hien_thi_danh_sach_chuyen_danh_bat_cua_tau(
    tau_ca_cursor OUT SYS_REFCURSOR,
    p_MaTauCa NVARCHAR2
    
)
IS
BEGIN
    OPEN tau_ca_cursor FOR
        SELECT * FROM CHUYEN_DANH_BAT cdb 
        WHERE cdb.MaTauCa = p_MaTauCa;

    EXCEPTION
    WHEN OTHERS THEN
        RAISE;
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
--Dang Ky 

CREATE OR REPLACE PROCEDURE Them_Chu_Tau(
    p_MaChuTau        NVARCHAR2,
    p_HoTen           NVARCHAR2,
    p_SDT             NVARCHAR2,
    p_DiaChi          NVARCHAR2,
    p_CCCD            NVARCHAR2
    
)
IS
BEGIN
    INSERT INTO CHU_TAU(MaChuTau,HoTen,SDT,DiaChi,CCCD)
    VALUES(p_MaChuTau,p_HoTen,p_SDT,NULLIF(TRIM(p_DiaChi), ''),p_CCCD);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE Them_tau_ca(
    p_MaTauCa            NVARCHAR2,
    p_SoDangKy           NVARCHAR2,
    p_LoaiTau            NVARCHAR2,
    p_ChieuDai           NUMBER,
    p_CongSuat           NUMBER,
    p_NamDongTau         INTEGER,
    p_MaChuTau           NVARCHAR2,
    p_MaNgheChinh        NVARCHAR2

)
IS
BEGIN
    INSERT INTO TAU_CA(MaTauCa,SoDangKy,LoaiTau,ChieuDai,CongSuat,NamDongTau,MaChuTau,MaNgheChinh)
    VALUES (p_MaTauCa, p_SoDangKy, p_LoaiTau, p_ChieuDai,p_CongSuat,p_NamDongTau,p_MaChuTau,p_MaNgheChinh);

    COMMIT;

    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE Them_Chuyen_Danh_Bat(
    p_MaChuyenDanhBat     NVARCHAR2,
    p_NgayXuatBen         DATE,
    p_NgayCapBen          DATE,
    p_CangDi              NVARCHAR2,
    p_CangVe              NVARCHAR2,
    p_MaTauCa             NVARCHAR2,
    p_MaNguTruong         NVARCHAR2
)
IS
BEGIN
    INSERT INTO CHUYEN_DANH_BAT(
        MaChuyenDanhBat,
        NgayXuatBen,
        NgayCapBen,
        CangDi,
        CangVe,
        MaTauCa,
        MaNguTruong
    )
    VALUES(
        p_MaChuyenDanhBat,
        p_NgayXuatBen,
        p_NgayCapBen,
        NULLIF(p_CangDi, ''),
        NULLIF(p_CangVe, ''),
        p_MaTauCa,
        p_MaNguTruong
    );

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
/

--Cap nhat ho so
--duyet thong tin chu tautau
CREATE OR REPLACE PROCEDURE cap_nhat_thong_tin_ho_so_chu_tau(
    p_trangthai NVARCHAR2,
    p_MaChuTau NVARCHAR2
)
IS
BEGIN
    UPDATE CHU_TAU
    SET TRANGTHAIDUYET = p_trangthai
    WHERE MACHUTAU = p_MaChuTau;
END;
/
--duyet thong tin tau ca
CREATE OR REPLACE PROCEDURE cap_nhat_thong_tin_ho_so_tau_ca(
    p_trangthai NVARCHAR2,
    p_MaTauCa NVARCHAR2
)
IS
BEGIN
    UPDATE TAU_CA
    SET TRANGTHAIDUYET = p_trangthai
    WHERE MATAUCA = p_MaTauCa;
END;
/
-- duyet thong tin chuyen danh bat
CREATE OR REPLACE PROCEDURE cap_nhat_thong_tin_ho_so_chuyen_danh_bat(
    p_trangthaiduyet NVARCHAR2,
    p_MaChuyenDanhBat NVARCHAR2
)
IS
BEGIN
    IF p_trangthaiduyet = 'DUYET' THEN
        UPDATE CHUYEN_DANH_BAT
        SET TRANGTHAIDUYET = p_trangthaiduyet
        WHERE MACHUYENDANHBAT = p_MaChuyenDanhBat;
    ELSE
        UPDATE CHUYEN_DANH_BAT
        SET TRANGTHAIDUYET = p_trangthaiduyet, TRANGTHAIHOATDONG = "DANG CHO|DA DK"
        WHERE MACHUYENDANHBAT = p_MaChuyenDanhBat;
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE cap_nhat_trang_thai_roi_cang(
    p_MaTauCa NVARCHAR2
)
IS
BEGIN
    UPDATE TAU_CA
    SET TRANGTHAIHOATDONG = "DANG HOAT DONG"
    WHERE MATAUCA = p_MaTauCa;
END;
/

CREATE OR REPLACE PROCEDURE cap_nhat_trang_thai_cap_cang(
    p_MaTauCa NVARCHAR2
)
IS
BEGIN
    UPDATE TAU_CA
    SET TRANGTHAIHOATDONG = "DANG CHO|CHUA DK"
    WHERE MATAUCA = p_MaTauCa;
END;
/

CREATE OR REPLACE PROCEDURE cap_nhat_thong_tin_chu_tau(
    p_MaChuTau        NVARCHAR2,
    p_HoTen           NVARCHAR2,
    p_SDT             NVARCHAR2,
    p_DiaChi          NVARCHAR2,
    p_CCCD            NVARCHAR2
)
IS
BEGIN
    UPDATE CHU_TAU
    SET HoTen = p_HoTen, SDT = p_SDT, DiaChi = p_DiaChi, CCCD = p_CCCD, TrangThaiDuyet = 'DANG CHO'
    WHERE p_MaChuTau = MaChuTau;
END;
/



--Ma Chu tau co duoc doi khong ? 
CREATE OR REPLACE PROCEDURE cap_nhat_thong_tin_tau_ca(
    p_MaTauCa            NVARCHAR2,
    p_LoaiTau            NVARCHAR2,
    p_ChieuDai           NUMBER,
    p_CongSuat           NUMBER,
    p_NamDongTau         INTEGER,
    --p_MaChuTau           NVARCHAR2 NOT NULL,
    p_MaNgheChinh        NVARCHAR2
)
IS
BEGIN
    UPDATE TAU_CA
    SET LoaiTau = p_LoaiTau, ChieuDai = p_ChieuDai, CongSuat = p_CongSuat, NamDongTau = p_NamDongTau,
    TrangThaiDuyet = 'DANG CHO', MaNgheChinh = p_MaNgheChinh
    WHERE MaTauCa = p_MaTauCa;

END;
/



CREATE OR REPLACE PROCEDURE cap_nhat_thong_tin_ngu_truong(
    p_MaNguTruong         NVARCHAR2,
    p_TenNguTruong        NVARCHAR2,
    p_ViTri               SDO_GEOMETRY,
    p_SoLuongTauHienTai   INTEGER,
    p_SoLuongTauToiDa     INTEGER
)
IS 
BEGIN
    UPDATE NGU_TRUONG
    SET TenNguTruong = p_TenNguTruong,ViTri=p_ViTri,SoLuongTauHienTai = p_SoLuongTauHienTai,SoLuongTauToiDa = p_SoLuongTauToiDa
    WHERE MANGUTRUONG = p_MaNguTruong;

END;
/
--theo doi trang thai

CREATE OR REPLACE PROCEDURE theo_doi_ho_so_Chu_Tau(
     chu_tau_cursor OUT SYS_REFCURSOR,
     p_MaChuTau NVARCHAR2
   
)
IS
BEGIN
    OPEN chu_tau_cursor FOR
        SELECT *
        FROM CHU_TAU ct
        WHERE ct.MACHUTAU = p_MaChuTau;
END;
/

CREATE OR REPLACE PROCEDURE theo_doi_ho_so_tau_ca(
    p_MaChuTau NVARCHAR2,
    tau_ca_cursor OUT SYS_REFCURSOR
)
IS
BEGIN
    OPEN tau_ca_cursor FOR
    SELECT * 
    FROM TAU_CA tc
    WHERE tc.MACHUTAU = p_MaChuTau;
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
        SELECT ct.HOTEN,
                tc.MATAUCA,tc.SODANGKY,tc.LOAITAU,tc.CHIEUDAI,tc.CONGSUAT,
                cdb.MACHUYENDANHBAT,cdb.NGAYCAPBEN,cdb.NGAYXUATBEN,cdb.CANGDI,cdb.CANGVE,
                ng.TENNGHE
        FROM TAU_CA tc 
        JOIN CHU_TAU ct on tc.MaChuTau = ct.MaChuTau
        JOIN CHUYEN_DANH_BAT cdb on tc.MaTauCa = cdb.MaChuTau
        JOIN TAU_NGHE t_n on t_n.MaTauCa = tc.MaTauCa
        JOIN NGHE ng on t_n.MaNghe = ng.MaNghe
        WHERE tc.MaTauCa = p_MaTauCa;
 END;   
/

--Thong ke

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
-- VI. CREATE FUNCTION

-- VII. TEST CASE
