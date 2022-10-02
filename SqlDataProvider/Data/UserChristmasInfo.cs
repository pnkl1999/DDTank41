using System;

namespace SqlDataProvider.Data
{

    public class UserChristmasInfo : DataObject
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

        private int _exp;
        public int exp
        {
            get
            {
                return _exp;
            }
            set
            {
                _exp= value;
                _isDirty = true;
            }
        }

        private int _awardState;
        public int awardState
        {
            get
            {
                return _awardState;
            }
            set
            {
                _awardState = value;
                _isDirty = true;
            }
        }

        private int _count;
        public int count
        {
            get
            {
                return _count;
            }
            set
            {
                _count = value;
                _isDirty = true;
            }
        }

        private int _packsNumber;
        public int packsNumber
        {
            get
            {
                return _packsNumber;
            }
            set
            {
                _packsNumber = value;
                _isDirty = true;
            }
        }

        private int _lastPacks;
        public int lastPacks
        {
            get
            {
                return _lastPacks;
            }
            set
            {
                _lastPacks = value;
                _isDirty = true;
            }
        }
        private int _dayPacks;
        public int dayPacks
        {
            get
            {
                return _dayPacks;
            }
            set
            {
                _dayPacks = value;
                _isDirty = true;
            }
        }
        private DateTime _gameBeginTime;
        public DateTime gameBeginTime
        {
            get
            {
                return _gameBeginTime;
            }
            set
            {
                _gameBeginTime = value;
                _isDirty = true;
            }
        }

        private DateTime _gameEndTime;
        public DateTime gameEndTime
        {
            get
            {
                return _gameEndTime;
            }
            set
            {
                _gameEndTime = value;
                _isDirty = true;
            }
        }

        private bool _isEnter;
        public bool isEnter
        {
            get
            {
                return _isEnter;
            }
            set
            {
                _isEnter = value;
                _isDirty = true;
            }
        }

        private int _AvailTime;
        public int AvailTime
        {
            get
            {
                return _AvailTime;
            }
            set
            {
                _AvailTime = value;
                _isDirty = true;
            }
        }
    }
}

