
package Model;


public class TauCa {
    private int maTauCa;
    private String soDangKy;
    private String loaiTau;
    private double chieuDai;
    private double congSuat;
    private int namDongTau;
    private boolean trangThaiHoatDong;
    private boolean trangThaiDuyet;
    private ChuTau chuTau;
    private Nghe ngheChinh;

    public TauCa(int maTauCa, String soDangKy, String loaiTau, double chieuDai, double congSuat, int namDongTau, boolean trangThaiHoatDong, boolean trangThaiDuyet, ChuTau chuTau, Nghe ngheChinh) {
        this.maTauCa = maTauCa;
        this.soDangKy = soDangKy;
        this.loaiTau = loaiTau;
        this.chieuDai = chieuDai;
        this.congSuat = congSuat;
        this.namDongTau = namDongTau;
        this.trangThaiHoatDong = trangThaiHoatDong;
        this.trangThaiDuyet = trangThaiDuyet;
        this.chuTau = chuTau;
        this.ngheChinh = ngheChinh;
    }
    public int getMaTauCa() {
        return maTauCa;
    }
    public void setMaTauCa(int maTauCa) {
        this.maTauCa = maTauCa;
    }
    public String getSoDangKy() {
        return soDangKy;
    }
    public void setSoDangKy(String soDangKy) {
        this.soDangKy = soDangKy;
    }
    public String getLoaiTau() {
        return loaiTau;
    }
    public void setLoaiTau(String loaiTau) {
        this.loaiTau = loaiTau;
    }
    public double getChieuDai() {
        return chieuDai;
    }
    public void setChieuDai(double chieuDai) {
        this.chieuDai = chieuDai;
    }
    public double getCongSuat() {
        return congSuat;
    }
    public void setCongSuat(double congSuat) {
        this.congSuat = congSuat;
    }
    public int getNamDongTau() {
        return namDongTau;
    }
    public void setNamDongTau(int namDongTau) {
        this.namDongTau = namDongTau;
    }
    public boolean isTrangThaiHoatDong() {
        return trangThaiHoatDong;
    }
    public void setTrangThaiHoatDong(boolean trangThaiHoatDong) {
        this.trangThaiHoatDong = trangThaiHoatDong;
    }
    public boolean isTrangThaiDuyet() {
        return trangThaiDuyet;
    }
    public void setTrangThaiDuyet(boolean trangThaiDuyet) {
        this.trangThaiDuyet = trangThaiDuyet;
    }
    public ChuTau getChuTau() {
        return chuTau;
    }
    public void setChuTau(ChuTau chuTau) {
        this.chuTau = chuTau;
    }
    public Nghe getNgheChinh() {
        return ngheChinh;
    }
    public void setNgheChinh(Nghe ngheChinh) {
        this.ngheChinh = ngheChinh;
    }

}
