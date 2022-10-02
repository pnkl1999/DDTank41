using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class TreasurePuzzleDataInfo : DataObject
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
        private int _puzzleID;
        public int PuzzleID
        {
            get { return _puzzleID; }
            set { _puzzleID = value; _isDirty = true; }
        }
        private int _hole1Need;
        public int hole1Need
        {
            get { return _hole1Need; }
            set { _hole1Need = value; _isDirty = true; }
        }
        private int _hole1Have;
        public int hole1Have
        {
            get { return _hole1Have; }
            set { _hole1Have = value; _isDirty = true; }
        }
        private int _hole2Need;
        public int hole2Need
        {
            get { return _hole2Need; }
            set { _hole2Need = value; _isDirty = true; }
        }
        private int _hole2Have;
        public int hole2Have
        {
            get { return _hole2Have; }
            set { _hole2Have = value; _isDirty = true; }
        }
        private int _hole3Need;
        public int hole3Need
        {
            get { return _hole3Need; }
            set { _hole3Need = value; _isDirty = true; }
        }
        private int _hole3Have;
        public int hole3Have
        {
            get { return _hole3Have; }
            set { _hole3Have = value; _isDirty = true; }
        }
        private int _hole4Need;
        public int hole4Need
        {
            get { return _hole4Need; }
            set { _hole4Need = value; _isDirty = true; }
        }
        private int _hole4Have;
        public int hole4Have
        {
            get { return _hole4Have; }
            set { _hole4Have = value; _isDirty = true; }
        }
        private int _hole5Need;
        public int hole5Need
        {
            get { return _hole5Need; }
            set { _hole5Need = value; _isDirty = true; }
        }
        private int _hole5Have;
        public int hole5Have
        {
            get { return _hole5Have; }
            set { _hole5Have = value; _isDirty = true; }
        }
        private int _hole6Need;
        public int hole6Need
        {
            get { return _hole6Need; }
            set { _hole6Need = value; _isDirty = true; }
        }
        private int _hole6Have;
        public int hole6Have
        {
            get { return _hole6Have; }
            set { _hole6Have = value; _isDirty = true; }
        }
        private bool _isGetAward;
        public bool IsGetAward
        {
            get { return _isGetAward; }
            set { _isGetAward = value; _isDirty = true; }
        }
        public bool canGetReward()
        {
            if (_isGetAward)
                return false;
            int need = _hole1Need + _hole2Need + _hole3Need + _hole4Need + _hole5Need + _hole6Need;
            int have = _hole1Have + _hole2Have + _hole3Have + _hole4Have + _hole5Have + _hole6Have;
            return need == have;
        }
    }
}