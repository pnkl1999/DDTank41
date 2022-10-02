using System;

namespace SqlDataProvider.Data
{
    public class AchievementDataInfo : DataObject
    {
        private int _achievementID;

        private DateTime _completedDate;

        private bool _isComplete;

        private int _userID;

        public int AchievementID
        {
			get
			{
				return _achievementID;
			}
			set
			{
				_achievementID = value;
				_isDirty = true;
			}
        }

        public DateTime CompletedDate
        {
			get
			{
				return _completedDate;
			}
			set
			{
				_completedDate = value;
				_isDirty = true;
			}
        }

        public bool IsComplete
        {
			get
			{
				return _isComplete;
			}
			set
			{
				_isComplete = value;
				_isDirty = true;
			}
        }

        public int UserID
        {
			get
			{
				return _userID;
			}
			set
			{
				_userID = value;
				_isDirty = true;
			}
        }
    }
}
