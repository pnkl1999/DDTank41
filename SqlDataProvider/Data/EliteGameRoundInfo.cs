namespace SqlDataProvider.Data
{
    public class EliteGameRoundInfo
    {
        private int int_0;

        private int int_1;

        private PlayerEliteGameInfo playerEliteGameInfo_0;

        private PlayerEliteGameInfo playerEliteGameInfo_1;

        private PlayerEliteGameInfo playerEliteGameInfo_2;

        public int RoundID
        {
			get
			{
				return int_0;
			}
			set
			{
				int_0 = value;
			}
        }

        public int RoundType
        {
			get
			{
				return int_1;
			}
			set
			{
				int_1 = value;
			}
        }

        public PlayerEliteGameInfo PlayerOne
        {
			get
			{
				return playerEliteGameInfo_0;
			}
			set
			{
				playerEliteGameInfo_0 = value;
			}
        }

        public PlayerEliteGameInfo PlayerTwo
        {
			get
			{
				return playerEliteGameInfo_1;
			}
			set
			{
				playerEliteGameInfo_1 = value;
			}
        }

        public PlayerEliteGameInfo PlayerWin
        {
			get
			{
				return playerEliteGameInfo_2;
			}
			set
			{
				playerEliteGameInfo_2 = value;
			}
        }
    }
}
