using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SqlDataProvider.Data
{
	public class DailyLeagueRewardItemInfo
	{
		public int ID { get; set; }

		public int TemplateID { get; set; }

		public int StrengthLevel { get; set; }

		public int AttackCompose { get; set; }

		public int DefendCompose { get; set; }

		public int LuckCompose { get; set; }

		public int AgilityCompose { get; set; }

		public bool IsBind { get; set; }

		public int ValidDate { get; set; }

		public int Count { get; set; }

		public int GroupId { get; set; }
	}
}
