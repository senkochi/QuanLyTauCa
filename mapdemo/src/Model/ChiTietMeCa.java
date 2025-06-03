
package Model;

public class ChiTietMeCa {
    private MeCa meCa;
    private ThuySan thuySan;
    private double khoiLuong;
    
    public ChiTietMeCa(MeCa meCa, ThuySan thuySan, double khoiLuong) {
        this.meCa = meCa;
        this.thuySan = thuySan;
        this.khoiLuong = khoiLuong;
    }

    public MeCa getMeCa() {
        return meCa;
    }

    public ThuySan getThuySan() {
        return thuySan;
    }

    public double getKhoiLuong() {
        return khoiLuong;
    }

    public void setMeCa(MeCa meCa) {
        this.meCa = meCa;
    }

    public void setThuySan(ThuySan thuySan) {
        this.thuySan = thuySan;
    }

    public void setKhoiLuong(double khoiLuong) {
        this.khoiLuong = khoiLuong;
    }
}
