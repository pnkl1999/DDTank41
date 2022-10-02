using System;

namespace SqlDataProvider.Data
{
    public class AchievementData : DataObject
    {
        private bool _IsComplete;

        private DateTime _CompleteDate;

        private int _UserID;

        private int _AchievementID;

        public int AchievementID
        {
			get
			{
				return _AchievementID;
			}
			set
			{
				_AchievementID = value;
				_isDirty = true;
			}
        }

        public DateTime CompletedDate
        {
			get
			{
				return _CompleteDate;
			}
			set
			{
				_CompleteDate = value;
				_isDirty = true;
			}
        }

        public bool IsComplete
        {
			get
			{
				return _IsComplete;
			}
			set
			{
				_IsComplete = value;
				_isDirty = true;
			}
        }

        public int UserID
        {
			get
			{
				return _UserID;
			}
			set
			{
				_UserID = value;
				_isDirty = true;
			}
        }

        public AchievementData()
        {
			UserID = 0;
			AchievementID = 0;
			IsComplete = false;
			CompletedDate = DateTime.Now;
        }
    }
}
