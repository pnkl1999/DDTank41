using System;
using System.Runtime.CompilerServices;

namespace SqlDataProvider.Data
{
    public class HotSpringRoomInfo
    {
        [CompilerGenerated]
		private DateTime dateTime_0;

        [CompilerGenerated]
		private DateTime dateTime_1;

        [CompilerGenerated]
		private int FxiFhyuqdi8;

        [CompilerGenerated]
		private int int_0;

        [CompilerGenerated]
		private int int_1;

        [CompilerGenerated]
		private int int_2;

        [CompilerGenerated]
		private int int_3;

        [CompilerGenerated]
		private int int_4;

        [CompilerGenerated]
		private int int_5;

        [CompilerGenerated]
		private string string_0;

        [CompilerGenerated]
		private string string_1;

        [CompilerGenerated]
		private string string_2;

        [CompilerGenerated]
		private string string_3;

        public int curCount
        {
			[CompilerGenerated]
			get
			{
				return int_3;
			}
			[CompilerGenerated]
			set
			{
				int_3 = value;
			}
        }

        public int effectiveTime
        {
			[CompilerGenerated]
			get
			{
				return int_2;
			}
			[CompilerGenerated]
			set
			{
				int_2 = value;
			}
        }

        public DateTime endTime
        {
			[CompilerGenerated]
			get
			{
				return dateTime_1;
			}
			[CompilerGenerated]
			set
			{
				dateTime_1 = value;
			}
        }

        public int maxCount
        {
			[CompilerGenerated]
			get
			{
				return int_5;
			}
			[CompilerGenerated]
			set
			{
				int_5 = value;
			}
        }

        public int playerID
        {
			[CompilerGenerated]
			get
			{
				return int_4;
			}
			[CompilerGenerated]
			set
			{
				int_4 = value;
			}
        }

        public string playerName
        {
			[CompilerGenerated]
			get
			{
				return string_2;
			}
			[CompilerGenerated]
			set
			{
				string_2 = value;
			}
        }

        public int roomID
        {
			[CompilerGenerated]
			get
			{
				return int_1;
			}
			[CompilerGenerated]
			set
			{
				int_1 = value;
			}
        }

        public string roomIntroduction
        {
			[CompilerGenerated]
			get
			{
				return string_3;
			}
			[CompilerGenerated]
			set
			{
				string_3 = value;
			}
        }

        public string roomName
        {
			[CompilerGenerated]
			get
			{
				return string_0;
			}
			[CompilerGenerated]
			set
			{
				string_0 = value;
			}
        }

        public int roomNumber
        {
			[CompilerGenerated]
			get
			{
				return int_0;
			}
			[CompilerGenerated]
			set
			{
				int_0 = value;
			}
        }

        public string roomPassword
        {
			[CompilerGenerated]
			get
			{
				return string_1;
			}
			[CompilerGenerated]
			set
			{
				string_1 = value;
			}
        }

        public int roomType
        {
			[CompilerGenerated]
			get
			{
				return FxiFhyuqdi8;
			}
			[CompilerGenerated]
			set
			{
				FxiFhyuqdi8 = value;
			}
        }

        public DateTime startTime
        {
			[CompilerGenerated]
			get
			{
				return dateTime_0;
			}
			[CompilerGenerated]
			set
			{
				dateTime_0 = value;
			}
        }

        public bool CanEnter()
        {
			return curCount < maxCount;
        }
    }
}
