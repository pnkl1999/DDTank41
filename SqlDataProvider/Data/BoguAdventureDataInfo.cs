using System;
using System.Collections.Generic;
using System.Text;
namespace SqlDataProvider.Data
{
    public class BoguAdventureDataInfo : DataObject
    {
        private int _ID;
        public int ID
        {
            get { return _ID; }
            set { _ID = value; _isDirty = true; }
        }
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private int _currentIndex;
        public int currentIndex
        {
            get { return _currentIndex; }
            set { _currentIndex = value; _isDirty = true; }
        }
        private int _hp;
        public int hp
        {
            get { return _hp; }
            set { _hp = value; _isDirty = true; }
        }
        private int _isAcquireAward1;
        public int isAcquireAward1
        {
            get { return _isAcquireAward1; }
            set { _isAcquireAward1 = value; _isDirty = true; }
        }
        private int _isAcquireAward2;
        public int isAcquireAward2
        {
            get { return _isAcquireAward2; }
            set { _isAcquireAward2 = value; _isDirty = true; }
        }
        private int _isAcquireAward3;
        public int isAcquireAward3
        {
            get { return _isAcquireAward3; }
            set { _isAcquireAward3 = value; _isDirty = true; }
        }
        private int _openCount;
        public int openCount
        {
            get { return _openCount; }
            set { _openCount = value; _isDirty = true; }
        }
        private bool _isFreeReset;
        public bool isFreeReset
        {
            get { return _isFreeReset; }
            set { _isFreeReset = value; _isDirty = true; }
        }
        private int _resetCount;
        public int resetCount
        {
            get { return _resetCount; }
            set { _resetCount = value; _isDirty = true; }
        }
        private string _cellInfo;
        public string cellInfo
        {
            get { return _cellInfo; }
            set { _cellInfo = value; _isDirty = true; }
        }
        private string _awardCount;
        public string awardCount
        {
            get { return _awardCount; }
            set { _awardCount = value; _isDirty = true; }
        }
        private DateTime _lastEnterGame;
        public DateTime lastEnterGame
        {
            get { return _lastEnterGame; }
            set { _lastEnterGame = value; _isDirty = true; }
        }
    }
}