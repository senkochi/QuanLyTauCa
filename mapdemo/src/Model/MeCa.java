
package Model;

import java.time.LocalDateTime;


public class MeCa {
    private int maMeCa;
    private double khoiLuongMeCa;
    private LocalDateTime thoiGianThaLuoi;
    private LocalDateTime thoiGianKeoLuoi;
    private String viTri;
    private ChuyenDanhBat chuyenDanhBat;

    public MeCa(int maMeCa, double khoiLuongMeCa, LocalDateTime thoiGianThaLuoi, LocalDateTime thoiGianKeoLuoi, String viTri, ChuyenDanhBat chuyenDanhBat) {
        this.maMeCa = maMeCa;
        this.khoiLuongMeCa = khoiLuongMeCa;
        this.thoiGianThaLuoi = thoiGianThaLuoi;
        this.thoiGianKeoLuoi = thoiGianKeoLuoi;
        this.viTri = viTri;
        this.chuyenDanhBat = chuyenDanhBat;
    }
    public int getMaMeCa() {
        return maMeCa;
    }

    public double getKhoiLuongMeCa() {
        return khoiLuongMeCa;
    }

    public LocalDateTime getThoiGianThaLuoi() {
        return thoiGianThaLuoi;
    }

    public LocalDateTime getThoiGianKeoLuoi() {
        return thoiGianKeoLuoi;
    }

    public String getViTri() {
        return viTri;
    }

    public ChuyenDanhBat getChuyenDanhBat() {
        return chuyenDanhBat;
    }
    public void setMaMeCa(int maMeCa) {
        this.maMeCa = maMeCa;
    }
    public void setKhoiLuongMeCa(double khoiLuongMeCa) {
        this.khoiLuongMeCa = khoiLuongMeCa;
    }

    public void setThoiGianThaLuoi(LocalDateTime thoiGianThaLuoi) {
        this.thoiGianThaLuoi = thoiGianThaLuoi;
    }

    public void setThoiGianKeoLuoi(LocalDateTime thoiGianKeoLuoi) {
        this.thoiGianKeoLuoi = thoiGianKeoLuoi;
    }

    public void setViTri(String viTri) {
        this.viTri = viTri;
    }

    public void setChuyenDanhBat(ChuyenDanhBat chuyenDanhBat) {
        this.chuyenDanhBat = chuyenDanhBat;
    }
}