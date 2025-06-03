
package Model;

import java.time.LocalDateTime;


public class ThoiTiet {
    private int maDuBao;
    private LocalDateTime thoiGianDuBao;
    private String khuVucAnhHuong;
    private String chiTietDuBao;

    public ThoiTiet(int maDuBao, LocalDateTime thoiGianDuBao, String khuVucAnhHuong, String chiTietDuBao) {
        this.maDuBao = maDuBao;
        this.thoiGianDuBao = thoiGianDuBao;
        this.khuVucAnhHuong = khuVucAnhHuong;
        this.chiTietDuBao = chiTietDuBao;
    }
    public int getMaDuBao() {
        return maDuBao;
    }

    public LocalDateTime getThoiGianDuBao() {
        return thoiGianDuBao;
    }

    public String getKhuVucAnhHuong() {
        return khuVucAnhHuong;
    }

    public String getChiTietDuBao() {
        return chiTietDuBao;
    }

    public void setMaDuBao(int maDuBao) {
        this.maDuBao = maDuBao;
    }

    public void setThoiGianDuBao(LocalDateTime thoiGianDuBao) {
        this.thoiGianDuBao = thoiGianDuBao;
    }

    public void setKhuVucAnhHuong(String khuVucAnhHuong) {
        this.khuVucAnhHuong = khuVucAnhHuong;
    }

    public void setChiTietDuBao(String chiTietDuBao) {
        this.chiTietDuBao = chiTietDuBao;
    }
}
