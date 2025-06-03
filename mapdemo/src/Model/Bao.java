
package Model;


public class Bao {
    private int maBao;
    private String tenBao;

    public Bao(int maBao, String tenBao) {
        this.maBao = maBao;
        this.tenBao = tenBao;
    }

    public int getMaBao() {
        return maBao;
    }

    public String getTenBao() {
        return tenBao;
    }

    public void setMaBao(int maBao) {
        this.maBao = maBao;
    }

    public void setTenBao(String tenBao) {
        this.tenBao = tenBao;
    }
}
