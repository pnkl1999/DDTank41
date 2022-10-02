using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class DiceDataInfo : DataObject
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
        private int _luckIntegral;
        public int LuckIntegral
        {
            get { return _luckIntegral; }
            set { _luckIntegral = value; _isDirty = true; }
        }
        private int _luckIntegralLevel;
        public int LuckIntegralLevel
        {
            get { return _luckIntegralLevel; }
            set { _luckIntegralLevel = value; _isDirty = true; }
        }
        private int _level;
        public int Level
        {
            get { return _level; }
            set { _level = value; _isDirty = true; }
        }
        private int _freeCount;
        public int FreeCount
        {
            get { return _freeCount; }
            set { _freeCount = value; _isDirty = true; }
        }
        private int _currentPosition;
        public int CurrentPosition
        {
            get { return _currentPosition; }
            set { _currentPosition = value; _isDirty = true; }
        }
        private bool _userFirstCell;
        public bool UserFirstCell
        {
            get { return _userFirstCell; }
            set { _userFirstCell = value; _isDirty = true; }
        }
        private string _awardArray;
        public string AwardArray
        {
            get { return _awardArray; }
            set { _awardArray = value; _isDirty = true; }
        }        
    }
}
