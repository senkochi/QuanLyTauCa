
package Model;


public class NguTruong {
    private int maNguTruong;
    private String tenNguTruong;
    private int viTri;
    private String soLuongTauHienTai;
    private String soLuongTauToiDa;

    public NguTruong(int maNguTruong, String tenNguTruong, int viTri, String soLuongTauHienTai, String soLuongTauToiDa) {
        this.maNguTruong = maNguTruong;
        this.tenNguTruong = tenNguTruong;
        this.viTri = viTri;
        this.soLuongTauHienTai = soLuongTauHienTai;
        this.soLuongTauToiDa = soLuongTauToiDa;
    }

    public int getMaNguTruong() {
        return maNguTruong;
    }

    public void setMaNguTruong(int maNguTruong) {
        this.maNguTruong = maNguTruong;
    }

    public String getTenNguTruong() {
        return tenNguTruong;
    }

    public void setTenNguTruong(String tenNguTruong) {
        this.tenNguTruong = tenNguTruong;
    }

    public int getViTri() {
        return viTri;
    }

    public void setViTri(int viTri) {
        this.viTri = viTri;
    }

    public String getSoLuongTauHienTai() {
        return soLuongTauHienTai;
    }

    public void setSoLuongTauHienTai(String soLuongTauHienTai) {
        this.soLuongTauHienTai = soLuongTauHienTai;
    }

    public String getSoLuongTauToiDa() {
        return soLuongTauToiDa;
    }

    public void setSoLuongTauToiDa(String soLuongTauToiDa) {
        this.soLuongTauToiDa = soLuongTauToiDa;
    }
}
