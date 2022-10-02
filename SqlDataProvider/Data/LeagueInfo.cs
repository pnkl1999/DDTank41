namespace SqlDataProvider.Data
{
    public class LeagueInfo : DataObject
    {
        private int _iD;
        private string _rankName;
        private int _NeedPoint;
        public int ID { get => _iD; set => _iD = value; }
        public string RankName { get => _rankName; set => _rankName = value; }
        public int NeedPoint { get => _NeedPoint; set => _NeedPoint = value; }
    }
}
