using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class KingGradeDataInfo : DataObject
    {
        private int _userID;
        public int UserID
        {
            get { return _userID; }
            set { _userID = value; _isDirty = true; }
        }
        private int _ddtKingGrade;
        public int ddtKingGrade
        {
            get { return _ddtKingGrade; }
            set { _ddtKingGrade = value; _isDirty = true; }
        }
        private int _currentExp;
        public int currentExp
        {
            get { return _currentExp; }
            set { _currentExp = value; _isDirty = true; }
        }
        private int _usableNum;
        public int usableNum
        {
            get { return _usableNum; }
            set { _usableNum = value; _isDirty = true; }
        }
        private int _attackLevel;
        public int AttackLevel
        {
            get { return _attackLevel; }
            set { _attackLevel = value; _isDirty = true; }
        }
        private int _defenceLevel;
        public int DefenceLevel
        {
            get { return _defenceLevel; }
            set { _defenceLevel = value; _isDirty = true; }
        }
        private int _agilityLevel;
        public int AgilityLevel
        {
            get { return _agilityLevel; }
            set { _agilityLevel = value; _isDirty = true; }
        }
        private int _luckyLevel;
        public int LuckyLevel
        {
            get { return _luckyLevel; }
            set { _luckyLevel = value; _isDirty = true; }
        }
        private int _magicAttackLevel;
        public int MagicAttackLevel
        {
            get { return _magicAttackLevel; }
            set { _magicAttackLevel = value; _isDirty = true; }
        }
        private int _magicDefenceLevel;
        public int MagicDefenceLevel
        {
            get { return _magicDefenceLevel; }
            set { _magicDefenceLevel = value; _isDirty = true; }
        }
    }
}

