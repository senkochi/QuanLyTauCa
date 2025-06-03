
package Model;


public class ChiTietTauNghe {
    private TauCa tauCa;
    private Nghe nghe;
    private String vungHoatDong;

    public ChiTietTauNghe(TauCa tauCa, Nghe nghe, String vungHoatDong) {
        this.tauCa = tauCa;
        this.nghe = nghe;
        this.vungHoatDong = vungHoatDong;
    }

    public TauCa getTauCa() {
        return tauCa;
    }

    public void setTauCa(TauCa tauCa) {
        this.tauCa = tauCa;
    }

    public Nghe getNghe() {
        return nghe;
    }

    public void setNghe(Nghe nghe) {
        this.nghe = nghe;
    }

    public String getVungHoatDong() {
        return vungHoatDong;
    }

    public void setVungHoatDong(String vungHoatDong) {
        this.vungHoatDong = vungHoatDong;
    }
}
