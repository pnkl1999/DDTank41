using System;
using System.Collections.Generic;

namespace SqlDataProvider.Data
{
    public class LanternriddlesInfo
    {
        private int m_doubleFreeCount;

        private int m_doublePrice;

        private DateTime m_endDate;

        private int m_hitFreeCount;

        private int m_hitPrice;

        private bool m_isDouble;

        private bool m_isHint;

        private int m_myInteger;

        private int m_option;

        private int m_playerID;

        private int m_questionIndex;

        private int m_questionNum;

        private int m_questionView;

        private Dictionary<int, LightriddleQuestInfo> m_questViews;

        public bool CanNextQuest=> m_questionIndex <= m_questionView - 1;

        public int DoubleFreeCount
        {
			get
			{
				return m_doubleFreeCount;
			}
			set
			{
				m_doubleFreeCount = value;
			}
        }

        public int DoublePrice
        {
			get
			{
				return m_doublePrice;
			}
			set
			{
				m_doublePrice = value;
			}
        }

        public DateTime EndDate
        {
			get
			{
				return m_endDate;
			}
			set
			{
				m_endDate = value;
			}
        }

        public LightriddleQuestInfo GetCurrentQuestion
        {
			get
			{
				if (m_questViews != null)
				{
					return m_questViews[m_questionIndex];
				}
				return m_questViews[1];
			}
        }

        public int GetQuestionID
        {
			get
			{
				if (m_questViews != null)
				{
					return m_questViews[m_questionIndex].QuestionID;
				}
				return 1;
			}
        }

        public int HitFreeCount
        {
			get
			{
				return m_hitFreeCount;
			}
			set
			{
				m_hitFreeCount = value;
			}
        }

        public int HitPrice
        {
			get
			{
				return m_hitPrice;
			}
			set
			{
				m_hitPrice = value;
			}
        }

        public bool IsDouble
        {
			get
			{
				return m_isDouble;
			}
			set
			{
				m_isDouble = value;
			}
        }

        public bool IsHint
        {
			get
			{
				return m_isHint;
			}
			set
			{
				m_isHint = value;
			}
        }

        public int MyInteger
        {
			get
			{
				return m_myInteger;
			}
			set
			{
				m_myInteger = value;
			}
        }

        public int Option
        {
			get
			{
				return m_option;
			}
			set
			{
				m_option = value;
			}
        }

        public int PlayerID
        {
			get
			{
				return m_playerID;
			}
			set
			{
				m_playerID = value;
			}
        }

        public int QuestionIndex
        {
			get
			{
				return m_questionIndex;
			}
			set
			{
				m_questionIndex = value;
			}
        }

        public int QuestionNum
        {
			get
			{
				return m_questionNum;
			}
			set
			{
				m_questionNum = value;
			}
        }

        public int QuestionView
        {
			get
			{
				return m_questionView;
			}
			set
			{
				m_questionView = value;
			}
        }

        public Dictionary<int, LightriddleQuestInfo> QuestViews
        {
			get
			{
				return m_questViews;
			}
			set
			{
				m_questViews = value;
			}
        }
    }
}
