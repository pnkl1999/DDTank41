using System;

namespace SqlDataProvider.Data
{
    public class RingstationConfigInfo
    {
        public string AwardFightLost { get; set; }

        public string AwardFightWin { get; set; }

        public int AwardNum { get; set; }

        public DateTime AwardTime { get; set; }

        public int buyCount { get; set; }

        public int buyPrice { get; set; }

        public int cdPrice { get; set; }

        public int ChallengeNum { get; set; }

        public string ChampionText { get; set; }

        public int ID { get; set; }

        public bool IsFirstUpdateRank { get; set; }

        public int AwardBattleByRank(int rank, bool isWin)
        {
			if (rank == 0 && isWin)
			{
				return 10;
			}
			if (!(rank != 0 || isWin))
			{
				return 5;
			}
			if (!string.IsNullOrEmpty(AwardFightLost))
			{
				if (string.IsNullOrEmpty(AwardFightWin))
				{
					return 0;
				}
				string[] strArray = AwardFightLost.Split('|');
				if (isWin)
				{
					strArray = AwardFightWin.Split('|');
				}
				if (strArray.Length < 3)
				{
					return 0;
				}
				string[] strArray2 = strArray;
				for (int index = 0; index < strArray2.Length; index++)
				{
					string[] strArray3 = strArray2[index].Split(',');
					if (strArray3.Length >= 2)
					{
						int num4 = int.Parse(strArray3[0].Split('-')[0]);
						int num5 = int.Parse(strArray3[0].Split('-')[1]);
						if (rank >= num4 && rank <= num5)
						{
							return int.Parse(strArray3[1]);
						}
						continue;
					}
					return 0;
				}
			}
			return 0;
        }

        public int AwardNumByRank(int rank)
        {
			switch (rank)
			{
			case 0:
				return 0;
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
			case 10:
			case 11:
			case 12:
			case 13:
			case 14:
			case 15:
			case 16:
			case 17:
			case 18:
			case 19:
			case 20:
			case 21:
			case 22:
			case 23:
			case 24:
			case 25:
			case 26:
			case 27:
			case 28:
			case 29:
				return AwardNum - 10 * rank;
			default:
				return AwardNum - 350;
			}
        }

        public bool IsEndTime()
        {
			return AwardTime.Date < DateTime.Now.Date;
        }
    }
}
