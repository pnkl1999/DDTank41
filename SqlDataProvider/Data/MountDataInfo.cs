using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class MountDataInfo : DataObject
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
        private int _curUseHorse;
        public int curUseHorse
        {
            get { return _curUseHorse; }
            set { _curUseHorse = value; _isDirty = true; }
        }
        private int _curLevel;
        public int curLevel
        {
            get { return _curLevel; }
            set { _curLevel = value; _isDirty = true; }
        }
        private int _curExp;
        public int curExp
        {
            get { return _curExp; }
            set { _curExp = value; _isDirty = true; }
        }
        private string _curHasSkill;
        public string curHasSkill
        {
            get { return _curHasSkill; }
            set { _curHasSkill = value; _isDirty = true; }
        }
        private string _horsePicCherish;
        public string horsePicCherish
        {
            get { return _horsePicCherish; }
            set { _horsePicCherish = value; _isDirty = true; }
        }    
    }
}
