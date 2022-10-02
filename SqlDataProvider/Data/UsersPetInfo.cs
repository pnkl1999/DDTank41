using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class UsersPetInfo : DataObject
    {
        public string[] GetSkillEquip()
        {

            string[] activeSlot = new string[] { "0,0", "-1,1", "-1,2", "-1,3", "-1,4" };

            if (Level >= 20 && Level < 30) { activeSlot[1] = "0,1"; }
            if (Level >= 30 && Level < 50)
            {
                activeSlot[1] = "0,1";
                activeSlot[2] = "0,2";
            }
            if (Level >= 50)
            {
                activeSlot[1] = "0,1";
                activeSlot[2] = "0,2";
                activeSlot[3] = "0,3";
            }
            if (VIPLevel >= 7) { activeSlot[4] = "0,4"; }

            string[] oldEquipSkill = SkillEquip.Split('|');
            List<string> skillIds = new List<string>();
            string[] skillArray = Skill.Split('|');
            for (int i = 0; i < skillArray.Length; i++)
            {
                skillIds.Add(skillArray[i].Split(',')[0]);
            }

            for (int i = 0; i < activeSlot.Length; i++)
            {
                if (i < oldEquipSkill.Length && skillIds.Contains(oldEquipSkill[i].Split(',')[0]))
                {
                    activeSlot[i] = oldEquipSkill[i];
                }
            }

            _skillEquip = activeSlot[0];
            for (int s = 1; s < activeSlot.Length; s++)
            {
                _skillEquip += "|" + activeSlot[s];
            }

            return activeSlot;
        }

        private string _skillEquip;
        public string SkillEquip
        {
            get
            {
                return _skillEquip;
            }
            set
            {
                _skillEquip = value;
                _isDirty = true;
            }
        }

        private string _skill;
        public string Skill
        {
            get
            {
                return _skill;
            }
            set
            {
                _skill = value;
                _isDirty = true;
            }
        }
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
        private int _vipLv;
        public int VIPLevel
        {
            get
            {
                return _vipLv;
            }
            set
            {
                _vipLv = value;
                _isDirty = true;
            }
        }
        private int _petID;
        public int PetID
        {
            get
            {
                return _petID;
            }
            set
            {
                _petID = value;
                _isDirty = true;
            }
        }
        private int _templateID;
        public int TemplateID
        {
            get
            {
                return _templateID;
            }
            set
            {
                _templateID = value;
                _isDirty = true;
            }
        }

        private string _name;
        public string Name
        {
            get
            {
                return _name;
            }
            set
            {
                _name = value;
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

        private int _attack;
        public int Attack
        {
            get { return _attack; }
            set { _attack = value; _isDirty = true; }
        }
        private int _defence;
        public int Defence
        {
            get { return _defence; }
            set { _defence = value; _isDirty = true; }
        }
        private int _luck;
        public int Luck
        {
            get { return _luck; }
            set { _luck = value; _isDirty = true; }
        }
        private int _agility;
        public int Agility
        {
            get { return _agility; }
            set { _agility = value; _isDirty = true; }
        }
        private int _blood;
        public int Blood
        {
            get { return _blood; }
            set { _blood = value; _isDirty = true; }
        }
        private int _damage;
        public int Damage
        {
            get { return _damage; }
            set { _damage = value; _isDirty = true; }
        }
        private int _guard;
        public int Guard
        {
            get { return _guard; }
            set { _guard = value; _isDirty = true; }
        }

        private int _attackGrow;
        public int AttackGrow
        {
            get
            {
                return _attackGrow;
            }
            set
            {
                _attackGrow = value;
                _isDirty = true;
            }
        }

        private int _defenceGrow;
        public int DefenceGrow
        {
            get
            {
                return _defenceGrow;
            }
            set
            {
                _defenceGrow = value;
                _isDirty = true;
            }
        }

        private int _luckGrow;
        public int LuckGrow
        {
            get
            {
                return _luckGrow;
            }
            set
            {
                _luckGrow = value;
                _isDirty = true;
            }
        }

        private int _agilityGrow;
        public int AgilityGrow
        {
            get
            {
                return _agilityGrow;
            }
            set
            {
                _agilityGrow = value;
                _isDirty = true;
            }
        }

        private int _bloodGrow;
        public int BloodGrow
        {
            get
            {
                return _bloodGrow;
            }
            set
            {
                _bloodGrow = value;
                _isDirty = true;
            }
        }

        private int _damageGrow;
        public int DamageGrow
        {
            get
            {
                return _damageGrow;
            }
            set
            {
                _damageGrow = value;
                _isDirty = true;
            }
        }

        private int _guardGrow;
        public int GuardGrow
        {
            get
            {
                return _guardGrow;
            }
            set
            {
                _guardGrow = value;
                _isDirty = true;
            }
        }

        private int _level;
        public int Level
        {
            get
            {
                return _level;
            }
            set
            {
                _level = value;
                _isDirty = true;
            }
        }
        public int MaxLevel()
        {
            switch (_breakGrade)
            {
                case 1:
                    return 63;
                case 2:
                    return 65;
                case 3:
                    return 68;
                case 4:
                    return 70;
            }
            return 60;
        }
        private int _gp;
        public int GP
        {
            get
            {
                return _gp;
            }
            set
            {
                _gp = value;
                _isDirty = true;
            }
        }

        private int _maxGP;
        public int MaxGP
        {
            get
            {
                return _maxGP;
            }
            set
            {
                _maxGP = value;
                _isDirty = true;
            }
        }

        private int _hunger;
        public int Hunger
        {
            get
            {
                return _hunger;
            }
            set
            {
                _hunger = value;
                _isDirty = true;
            }
        }

        public int PetHappyStar
        {
            get
            {
                double starPercent = (double)_hunger / 10000 * 100;
                int star = 3;
                if (starPercent < 80)// các chỉ số giảm 20%
                    star = 2;
                if (starPercent < 60)// các chỉ số giảm 40%
                    star = 1;
                return star;
            }
        }

        private int _mp;
        public int MP
        {
            get
            {
                return _mp;
            }
            set
            {
                _mp = value;
                _isDirty = true;
            }
        }

        private bool _isEquip;
        public bool IsEquip
        {
            get
            {
                return _isEquip;
            }
            set
            {
                _isEquip = value;
                _isDirty = true;
            }
        }

        private int _place;
        public int Place
        {
            get
            {
                return _place;
            }
            set
            {
                _place = value;
                _isDirty = true;
            }
        }

        private int _currentStarExp;
        public int currentStarExp
        {
            get
            {
                return _currentStarExp;
            }
            set
            {
                _currentStarExp = value;
                _isDirty = true;
            }
        }

        private bool _isExit;
        public bool IsExit
        {
            get
            {
                return _isExit;
            }
            set
            {
                _isExit = value;
                _isDirty = true;
            }
        }
        private int _breakGrade;
        public int breakGrade
        {
            get { return _breakGrade; }
            set { _breakGrade = value; _isDirty = true; }
        }
        private int _breakAttack;
        public int breakAttack
        {
            get { return _breakAttack; }
            set { _breakAttack = value; _isDirty = true; }
        }
        private int _breakDefence;
        public int breakDefence
        {
            get { return _breakDefence; }
            set { _breakDefence = value; _isDirty = true; }
        }
        private int _breakAgility;
        public int breakAgility
        {
            get { return _breakAgility; }
            set { _breakAgility = value; _isDirty = true; }
        }
        private int _breakLuck;
        public int breakLuck
        {
            get { return _breakLuck; }
            set { _breakLuck = value; _isDirty = true; }
        }
        private int _breakBlood;
        public int breakBlood
        {
            get { return _breakBlood; }
            set { _breakBlood = value; _isDirty = true; }
        }
        public int ReduceProp(int val)
        {
            if (PetHappyStar == 2)
                return val * 20 / 100;
            if (PetHappyStar == 1)
                return val * 40 / 100;
            return 0;
        }
        //start total    
        List<PetEquipInfo> m_peEquips = new List<PetEquipInfo>();
        public List<PetEquipInfo> PetEquips
        {
            get
            {
                return m_peEquips;
            }
            set
            {
                m_peEquips = value;
            }
        }

        private string _eqPets;
        public string eQPets
        {
            get { return _eqPets; }
            set { _eqPets = value; _isDirty = true; }
        }

        private string _baseProp;
        public string BaseProp
        {
            get { return _baseProp; }
            set { _baseProp = value; _isDirty = true; }
        }

        private int addProp = 0;
        public int TotalAttack
        {
            get
            {
                addProp = 0;
                foreach (PetEquipInfo item in PetEquips)
                {
                    if (item.IsValidItem() && item.Template != null)
                    {
                        addProp += item.Template.Attack;
                    }
                }
                return (Attack - ReduceProp(Attack)) + addProp + _breakAttack;
            }
        }

        public int TotalDefence
        {
            get
            {
                addProp = 0;

                foreach (PetEquipInfo item in PetEquips)
                {
                    if (item.IsValidItem() && item.Template != null)
                    {
                        addProp += item.Template.Defence;
                    }
                }

                return (Defence - ReduceProp(Defence)) + addProp + _breakDefence;
            }
        }

        public int TotalLuck
        {
            get
            {
                addProp = 0;

                foreach (PetEquipInfo item in PetEquips)
                {
                    if (item.IsValidItem() && item.Template != null)
                    {
                        addProp += item.Template.Luck;
                    }
                }

                return (Luck - ReduceProp(Luck)) + addProp + breakLuck;
            }
        }
        public int TotalAgility
        {
            get
            {
                addProp = 0;

                foreach (PetEquipInfo item in PetEquips)
                {
                    if (item.IsValidItem() && item.Template != null)
                    {
                        addProp += item.Template.Agility;
                    }
                }

                return (Agility - ReduceProp(Agility)) + addProp + _breakAgility;
            }
        }
        public int TotalBlood
        {
            get
            {
                return (Blood - ReduceProp(Blood)) + _breakBlood;
            }

        }

        private double[] GetAddedPropArr(int grade, double[] propArr)
        {
            double[] arr = new double[propArr.Length];
            arr[0] = propArr[0] * Math.Pow(2, grade - 1);
            for (int i = 1; i < propArr.Length; i++)
            {
                arr[i] = propArr[i] * Math.Pow(1.5, grade - 1);
            }
            return arr;
        }

        public void BuildProp(UsersPetInfo petInfo)
        {
            double[] _oldPropArr = new double[] { BloodGrow * 10, AttackGrow, DefenceGrow, AgilityGrow, LuckGrow };
            double[] _oldGrowArr = new double[] { BloodGrow, AttackGrow, DefenceGrow, AgilityGrow, LuckGrow };

            double[] _propLevelArr_one = _oldPropArr;
            double[] _propLevelArr_two = _oldPropArr;
            double[] _propLevelArr_three = _oldPropArr;

            double[] _growLevelArr_one = GetAddedPropArr(1, _oldGrowArr);
            double[] _growLevelArr_two = GetAddedPropArr(2, _oldGrowArr);
            double[] _growLevelArr_three = GetAddedPropArr(3, _oldGrowArr);

            double[] propArr = new double[_propLevelArr_one.Length];

            if (Level < 30)
            {
                for (int p1 = 0; p1 < _propLevelArr_one.Length; p1++)
                {
                    _propLevelArr_one[p1] = _propLevelArr_one[p1] + ((Level - 1) * _growLevelArr_one[p1]);
                    _propLevelArr_one[p1] = Math.Ceiling(_propLevelArr_one[p1] / 10) / 10;
                }
                propArr = _propLevelArr_one;
            }
            else if (Level < 50)
            {
                for (int p2 = 0; p2 < _propLevelArr_two.Length; p2++)
                {
                    _propLevelArr_two[p2] = _propLevelArr_two[p2] + ((Level - 30) * _growLevelArr_two[p2] + 29 * _growLevelArr_one[p2]);
                    _propLevelArr_two[p2] = Math.Ceiling(_propLevelArr_two[p2] / 10) / 10;
                }
                propArr = _propLevelArr_two;
            }
            else
            {
                for (int p3 = 0; p3 < _propLevelArr_three.Length; p3++)
                {
                    _propLevelArr_three[p3] = _propLevelArr_three[p3] + ((Level - 50) * _growLevelArr_three[p3] + 20 * _growLevelArr_two[p3] + 29 * _growLevelArr_one[p3]);
                    _propLevelArr_three[p3] = Math.Ceiling(_propLevelArr_three[p3] / 10) / 10;
                }
                propArr = _propLevelArr_three;
            }
            _blood = (int)propArr[0];
            _attack = (int)propArr[1];
            _defence = (int)propArr[2];
            _agility = (int)propArr[3];
            _luck = (int)propArr[4];
        }
    }
}