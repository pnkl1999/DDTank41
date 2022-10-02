using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class CardAchievementDataInfo : DataObject
    {
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private int _achievementID;
        public int AchievementID
        {
            get { return _achievementID; }
            set { _achievementID = value; _isDirty = true; }
        }
        private int _condition;
        public int Condition
        {
            get { return _condition; }
            set { _condition = value; _isDirty = true; }
        }
        private DateTime _completedDate;
        public DateTime CompletedDate
        {
            get { return _completedDate; }
            set { _completedDate = value; _isDirty = true; }
        }
        private int _isComplete;
        public int IsComplete
        {
            get { return _isComplete; }
            set { _isComplete = value; _isDirty = true; }
        }
    }
}

