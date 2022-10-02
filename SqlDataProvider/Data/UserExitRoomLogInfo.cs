using System;

namespace SqlDataProvider.Data
{
    public class UserExitRoomLogInfo
    {
        public int UserID { get; set; }

        public int TotalExitTime { get; set; }

        public DateTime LastLogout { get; set; }

        public DateTime TimeBlock { get; set; }

        public bool IsNoticed { get; set; }

        public bool CanNotice
        {
			get
			{
				if (TotalExitTime <= 3 || IsNoticed)
				{
					return false;
				}
				IsNoticed = true;
				return true;
			}
        }
    }
}
