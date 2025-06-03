
package Model;

import java.time.LocalDate;


public class LogHaiTrinh {
    private int maLogHaiTrinh;
    private LocalDate thoiGian;
    private String viTri;
    private double vanToc;
    private String huongDiChuyen;
    private ChuyenDanhBat chuyenDanhBat;

    public LogHaiTrinh(int maLogHaiTrinh, LocalDate thoiGian, String viTri, double vanToc, String huongDiChuyen, ChuyenDanhBat chuyenDanhBat) {
        this.maLogHaiTrinh = maLogHaiTrinh;
        this.thoiGian = thoiGian;
        this.viTri = viTri;
        this.vanToc = vanToc;
        this.huongDiChuyen = huongDiChuyen;
        this.chuyenDanhBat = chuyenDanhBat;
    }
    public int getMaLogHaiTrinh() {
        return maLogHaiTrinh;
    }

    public LocalDate getThoiGian() {
        return thoiGian;
    }

    public String getViTri() {
        return viTri;
    }

    public double getVanToc() {
        return vanToc;
    }

    public String getHuongDiChuyen() {
        return huongDiChuyen;
    }

    public ChuyenDanhBat getChuyenDanhBat() {
        return chuyenDanhBat;
    }
    public void setMaLogHaiTrinh(int maLogHaiTrinh) {
        this.maLogHaiTrinh = maLogHaiTrinh;
    }
    public void setThoiGian(LocalDate thoiGian) {
        this.thoiGian = thoiGian;
    }
    public void setViTri(String viTri) {
        this.viTri = viTri;
    }
    public void setVanToc(double vanToc) {
        this.vanToc = vanToc;
    }
    public void setHuongDiChuyen(String huongDiChuyen) {
        this.huongDiChuyen = huongDiChuyen;
    }
    public void setChuyenDanhBat(ChuyenDanhBat chuyenDanhBat) {
        this.chuyenDanhBat = chuyenDanhBat;
    }
}
