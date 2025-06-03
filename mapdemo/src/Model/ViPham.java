
package Model;

import java.time.LocalDate;


public class ViPham {
    private int maViPham;
    private LocalDate thoiGian;
    private String viTri;
    private String moTa;
    private ChuyenDanhBat chuyenDanhBat;

    public ViPham(int maViPham, LocalDate thoiGian, String viTri, String moTa, ChuyenDanhBat chuyenDanhBat) {
        this.maViPham = maViPham;
        this.thoiGian = thoiGian;
        this.viTri = viTri;
        this.moTa = moTa;
        this.chuyenDanhBat = chuyenDanhBat;
    }
    public int getMaViPham() {
        return maViPham;
    }

    public LocalDate getThoiGian() {
        return thoiGian;
    }

    public String getViTri() {
        return viTri;
    }

    public String getMoTa() {
        return moTa;
    }

    public ChuyenDanhBat getChuyenDanhBat() {
        return chuyenDanhBat;
    }
    public void setMaViPham(int maViPham) {
        this.maViPham = maViPham;
    }

    public void setThoiGian(LocalDate thoiGian) {
        this.thoiGian = thoiGian;
    }

    public void setViTri(String viTri) {
        this.viTri = viTri;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public void setChuyenDanhBat(ChuyenDanhBat chuyenDanhBat) {
        this.chuyenDanhBat = chuyenDanhBat;
    }
}