using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UserHomeInfo : DataObject
    {
        private int _id;
        public int ID
        {
            get { return _id; }
            set { _id = value; _isDirty = true; }
        }
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private int _houseStage;
        public int houseStage
        {
            get { return _houseStage; }
            set { _houseStage = value; _isDirty = true; }
        }
        private int _energyCount;
        public int energyCount
        {
            get { return _energyCount; }
            set { _energyCount = value; _isDirty = true; }
        }
        private int _drinkCount;
        public int drinkCount
        {
            get { return _drinkCount; }
            set { _drinkCount = value; _isDirty = true; }
        }
        private DateTime _cdEndTime;
        public DateTime cdEndTime
        {
            get { return _cdEndTime; }
            set { _cdEndTime = value; _isDirty = true; }
        }
        private int _pourCount;
        public int pourCount
        {
            get { return _pourCount; }
            set { _pourCount = value; _isDirty = true; }
        }       
        private int _tasteCount;
        public int tasteCount
        {
            get { return _tasteCount; }
            set { _tasteCount = value; _isDirty = true; }
        }
        private int _enableFight;
        public int enableFight
        {
            get { return _enableFight; }
            set { _enableFight = value; _isDirty = true; }
        }
        private int _gold;
        public int Gold
        {
            get { return _gold; }
            set { _gold = value; _isDirty = true; }
        }
        private int _blood;
        public int Blood
        {
            get { return _blood; }
            set { _blood = value; _isDirty = true; }
        }
        private string _yardAdornInfo;
        public string yardAdornInfo
        {
            get { return _yardAdornInfo; }
            set { _yardAdornInfo = value; _isDirty = true; }
        }        
        private string _houseAdornInfo;
        public string houseAdornInfo
        {
            get { return _houseAdornInfo; }
            set { _houseAdornInfo = value; _isDirty = true; }
        }
        private string _logTaste;
        public string LogTaste
        {
            get { return _logTaste; }
            set { _logTaste = value; _isDirty = true; }
        }
        private DateTime _lastLogin;
        public DateTime LastLogin
        {
            get { return _lastLogin; }
            set { _lastLogin = value; _isDirty = true; }
        }
        private int _fishGameTime;
        public int fishGameTime
        {
            get { return _fishGameTime; }
            set { _fishGameTime = value; _isDirty = true; }
        }
        private int _fishScore;
        public int fishScore
        {
            get { return _fishScore; }
            set { _fishScore = value; _isDirty = true; }
        }
        private int _dayScore;
        public int dayScore
        {
            get { return _dayScore; }
            set { _dayScore = value; _isDirty = true; }
        }
        private int _maxScore;
        public int maxScore
        {
            get { return _maxScore; }
            set { _maxScore = value; _isDirty = true; }
        }
        private int _remainCount;
        public int remainCount
        {
            get { return _remainCount; }
            set { _remainCount = value; _isDirty = true; }
        }
        private string _moneyTrees;
        public string MoneyTrees
        {
            get { return _moneyTrees; }
            set { _moneyTrees = value; _isDirty = true; }
        }
        private int _numRedPkgRemain;
        public int NumRedPkgRemain
        {
            get { return _numRedPkgRemain; }
            set { _numRedPkgRemain = value; _isDirty = true; }
        }
    }
}