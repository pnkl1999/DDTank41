using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UserTrailEliteInfo : DataObject
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
        private int _trailEliteScore;
        public int trailEliteScore
        {
            get { return _trailEliteScore; }
            set { _trailEliteScore = value; _isDirty = true; }
        }
        private int _trailEliteTotal;
        public int trailEliteTotal
        {
            get { return _trailEliteTotal; }
            set { _trailEliteTotal = value; _isDirty = true; }
        }
        private int _trailEliteWin;
        public int trailEliteWin
        {
            get { return _trailEliteWin; }
            set { _trailEliteWin = value; _isDirty = true; }
        }
        private int _trailEliteRankTotal;
        public int trailEliteRankTotal
        {
            get { return _trailEliteRankTotal; }
            set { _trailEliteRankTotal = value; _isDirty = true; }
        }
        private int _trailEliteRankWin;
        public int trailEliteRankWin
        {
            get { return _trailEliteRankWin; }
            set { _trailEliteRankWin = value; _isDirty = true; }
        }
        private bool _trailEliteIsUpRank;
        public bool trailEliteIsUpRank
        {
            get { return _trailEliteIsUpRank; }
            set { _trailEliteIsUpRank = value; _isDirty = true; }
        }
        private int _trailEliteLevel;
        public int trailEliteLevel
        {
            get { return _trailEliteLevel; }
            set { _trailEliteLevel = value; _isDirty = true; }
        }
    }
}

