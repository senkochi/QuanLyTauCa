
package Model;

import java.time.LocalDate;

public class ChuyenDanhBat {
    private int maChuyenDanhBat;
    private LocalDate ngayXuatBen;
    private LocalDate ngayCapBen;
    private String cangDi;
    private String cangVe;
    private double tongKhoiLuong;
    private boolean trangThaiDuyet;
    private boolean trangThaiHoatDong;
    private TauCa tauCa;
    private NguTruong nguTruong;
    private MeCa meCa;

    public ChuyenDanhBat(int maChuyenDanhBat, LocalDate ngayXuatBen, LocalDate ngayCapBen, String cangDi, String cangVe, double tongKhoiLuong, boolean trangThaiDuyet, boolean trangThaiHoatDong, TauCa tauCa, NguTruong nguTruong, MeCa meCa) {
        this.maChuyenDanhBat = maChuyenDanhBat;
        this.ngayXuatBen = ngayXuatBen;
        this.ngayCapBen = ngayCapBen;
        this.cangDi = cangDi;
        this.cangVe = cangVe;
        this.tongKhoiLuong = tongKhoiLuong;
        this.trangThaiDuyet = trangThaiDuyet;
        this.trangThaiHoatDong = trangThaiHoatDong;
        this.tauCa = tauCa;
        this.nguTruong = nguTruong;
        this.meCa = meCa;
    }
    public int getMaChuyenDanhBat() {
        return maChuyenDanhBat;
    }

   public LocalDate getNgayXuatBen() {
       return ngayXuatBen;
   }

   public LocalDate getNgayCapBen() {
       return ngayCapBen;
   }

   public String getCangDi() {
       return cangDi;
   }

   public String getCangVe() {
       return cangVe;
   }

   public double getTongKhoiLuong() {
       return tongKhoiLuong;
   }

   public boolean isTrangThaiDuyet() {
       return trangThaiDuyet;
   }

   public boolean isTrangThaiHoatDong() {
       return trangThaiHoatDong;
   }

   public TauCa getTauCa() {
       return tauCa;
   }

   public NguTruong getNguTruong() {
       return nguTruong;
   }
    public void setMaChuyenDanhBat(int maChuyenDanhBat) {
         this.maChuyenDanhBat = maChuyenDanhBat;
    }

   public void setNgayXuatBen(LocalDate ngayXuatBen) {
       this.ngayXuatBen = ngayXuatBen;
   }

   public void setNgayCapBen(LocalDate ngayCapBen) {
       this.ngayCapBen = ngayCapBen;
   }

   public void setCangDi(String cangDi) {
       this.cangDi = cangDi;
   }

   public void setCangVe(String cangVe) {
       this.cangVe = cangVe;
   }

   public void setTongKhoiLuong(double tongKhoiLuong) {
       this.tongKhoiLuong = tongKhoiLuong;
   }

   public void setTrangThaiDuyet(boolean trangThaiDuyet) {
       this.trangThaiDuyet = trangThaiDuyet;
   }

   public void setTrangThaiHoatDong(boolean trangThaiHoatDong) {
       this.trangThaiHoatDong = trangThaiHoatDong;
   }

   public void setTauCa(TauCa tauCa) {
       this.tauCa = tauCa;
   }

   public void setNguTruong(NguTruong nguTruong) {
       this.nguTruong = nguTruong;
   }

   public void setMeCa(MeCa meCa) {
       this.meCa = meCa;
   }
    public MeCa getMeCa() {
         return meCa;
    }
}
