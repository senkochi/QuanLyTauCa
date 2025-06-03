
package Model;

public class ThuySan {
    private int maThuySan;
    private String tenThuySan;

    public ThuySan(int maThuySan, String tenThuySan) {
        this.maThuySan = maThuySan;
        this.tenThuySan = tenThuySan;
    }

    public int getMaThuySan() {
        return maThuySan;
    }
    public void setMaThuySan(int maThuySan) {
        this.maThuySan = maThuySan;
    }
    public String getTenThuySan() {
        return tenThuySan;
    }
    public void setTenThuySan(String tenThuySan) {
        this.tenThuySan = tenThuySan;
    }
}
