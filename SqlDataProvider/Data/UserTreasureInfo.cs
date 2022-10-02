using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UserTreasureInfo : DataObject
    {
        private int _ID;
        public int ID
        {
            get
            {
                return _ID;
            }
            set
            {
                _ID = value;
                _isDirty = true;
            }
        }

        private int _userID;
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

        private string _NickName;
        public string NickName
        {
            get
            {
                return _NickName;
            }
            set
            {
                _NickName = value;
                _isDirty = true;
            }
        }

        private int _logoinDays;
        public int logoinDays
        {
            get
            {
                return _logoinDays;
            }
            set
            {
                _logoinDays = value;
                _isDirty = true;
            }
        }
        //------------------
        private int _treasure;
        public int treasure
        {
            get
            {
                return _treasure;
            }
            set
            {
                _treasure = value;
                _isDirty = true;
            }
        }
        private int _treasureAdd;
        public int treasureAdd
        {
            get
            {
                return _treasureAdd;
            }
            set
            {
                _treasureAdd = value;
                _isDirty = true;
            }
        }
        private int _friendHelpTimes;
        public int friendHelpTimes
        {
            get
            {
                return _friendHelpTimes;
            }
            set
            {
                _friendHelpTimes = value;
                _isDirty = true;
            }
        }
        private bool _isEndTreasure;
        public bool isEndTreasure
        {
            get
            {
                return _isEndTreasure;
            }
            set
            {
                _isEndTreasure = value;
                _isDirty = true;
            }
        }
        private bool _isBeginTreasure;
        public bool isBeginTreasure
        {
            get
            {
                return _isBeginTreasure;
            }
            set
            {
                _isBeginTreasure = value;
                _isDirty = true;
            }
        }
        //LastLoginDay
        private DateTime _lastLoginDay;
        public DateTime LastLoginDay
        {
            get
            {
                return _lastLoginDay;
            }
            set
            {
                _lastLoginDay = value;
                _isDirty = true;
            }
        }
        public bool isValidDate()
        {
            return _lastLoginDay.Date < DateTime.Now.Date;
        }
    }
}
