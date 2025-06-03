
package Model;


public class ChuTau {
    private int maChuTau;
    private String tenChuTau;
    private String soDienThoai;
    private String diaChi;
    private String cccd;
    private boolean trangThaiDuyet;

    public ChuTau(int maChuTau, String tenChuTau, String soDienThoai, String diaChi, String cccd, boolean trangThaiDuyet) {
        this.maChuTau = maChuTau;
        this.tenChuTau = tenChuTau;
        this.soDienThoai = soDienThoai;
        this.diaChi = diaChi;
        this.cccd = cccd;
        this.trangThaiDuyet = trangThaiDuyet;
    }

    public int getMaChuTau() {
        return maChuTau;
    }
    public void setMaChuTau(int maChuTau) {
        this.maChuTau = maChuTau;
    }
    public String getTenChuTau() {
        return tenChuTau;
    }
    public void setTenChuTau(String tenChuTau) {
        this.tenChuTau = tenChuTau;
    }
    public String getSoDienThoai() {
        return soDienThoai;
    }
    public void setSoDienThoai(String soDienThoai) {
        this.soDienThoai = soDienThoai;
    }
    public String getDiaChi() {
        return diaChi;
    }
    public void setDiaChi(String diaChi) {
        this.diaChi = diaChi;
    }
    public String getCccd() {
        return cccd;
    }
    public void setCccd(String cccd) {
        this.cccd = cccd;
    }
    public boolean isTrangThaiDuyet() {
        return trangThaiDuyet;
    }
    public void setTrangThaiDuyet(boolean trangThaiDuyet) {
        this.trangThaiDuyet = trangThaiDuyet;
    }
}
