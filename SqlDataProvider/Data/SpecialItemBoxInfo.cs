using System;

namespace SqlDataProvider.Data
{
    public class SpecialItemBoxInfo
    {
        public int PetScore { get; set; }
        public int DamageScore { get; set; }
        public int EquestrianScore { get; set; }
        public int LaurelScore { get; set; }
        public int SummerScore { get; set; }
        public int Gold { get; set; }
        public int Offer { get; set; }
        public long Money { get; set; }
        public int DDTMoney { get; set; }
        public int Medal { get; set; }
        public int Honor { get; set; }
        public int HardCurrency { get; set; }
        public int LeagueMoney { get; set; }
        public int UseableScore { get; set; }
        public int Prestge { get; set; }
        public int LoveScore { get; set; }
        public int RingScore { get; set; }
        public int MagicstoneScore { get; set; }
        public int Exp { get; set; }
        public int iTemplateID { get; set; }
        public int iCount { get; set; }
        public int FishScore { get; set; }
        public int CrystalScore { get; set; }
        public int PayValue()
        {
          return  PayValue(1);
        }
        public int PayValue(int count)
        {
            Money *= count;            
            DDTMoney *= count;
            Offer *= count;
            Gold *= count;
            SummerScore *= count;
            LeagueMoney *= count;
            HardCurrency *= count;
            PetScore *= count;
            DamageScore *= count;
            FishScore *= count;
            return FishScore + DamageScore + PetScore + HardCurrency + Gold + (int)Money + Offer + DDTMoney + LeagueMoney + SummerScore;
        }
    }
}
