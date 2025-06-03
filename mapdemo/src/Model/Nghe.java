
package Model;

public class Nghe {
    private int maNghe;
    private String tenNghe;

    public Nghe(int maNghe, String tenNghe) {
        this.maNghe = maNghe;
        this.tenNghe = tenNghe;
    }
    public int getMaNghe() {
        return maNghe;
    }
    public void setMaNghe(int maNghe) {
        this.maNghe = maNghe;
    }
    public String getTenNghe() {
        return tenNghe;
    }
    public void setTenNghe(String tenNghe) {
        this.tenNghe = tenNghe;
    }
}
