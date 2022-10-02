namespace SqlDataProvider.Data
{
    public class PlayerEliteGameInfo
    {
        private string yfgFrdHamEK;

        public int UserID { get; set; }

        public string NickName
        {
			get
			{
				return yfgFrdHamEK;
			}
			set
			{
				yfgFrdHamEK = value;
			}
        }

        public int GameType { get; set; }

        public int Rank { get; set; }

        public int CurrentPoint { get; set; }

        public int Status { get; set; }

        public int Winer { get; set; }

        public bool ReadyStatus { get; set; }
    }
}
