
package Model;

import java.time.LocalDateTime;


public class LogDuongDiBao {
    private int maLogDuongDi;
    private LocalDateTime thoiGian;
    private String viTri;
    private String mucDo;
    private Bao bao;

    public LogDuongDiBao(int maLogDuongDi, LocalDateTime thoiGian, String viTri, String mucDo, Bao bao) {
        this.maLogDuongDi = maLogDuongDi;
        this.thoiGian = thoiGian;
        this.viTri = viTri;
        this.mucDo = mucDo;
        this.bao = bao;
    }
    public int getMaLogDuongDi() {
        return maLogDuongDi;
    }
    public LocalDateTime getThoiGian() {
        return thoiGian;
    }
    public String getViTri() {
        return viTri;
    }
    public String getMucDo() {
        return mucDo;
    }
    public Bao getBao() {
        return bao;
    }
    public void setMaLogDuongDi(int maLogDuongDi) {
        this.maLogDuongDi = maLogDuongDi;
    }
    public void setThoiGian(LocalDateTime thoiGian) {
        this.thoiGian = thoiGian;
    }
    public void setViTri(String viTri) {
        this.viTri = viTri;
    }
    public void setMucDo(String mucDo) {
        this.mucDo = mucDo;
    }
    public void setBao(Bao bao) {
        this.bao = bao;
    }
}
