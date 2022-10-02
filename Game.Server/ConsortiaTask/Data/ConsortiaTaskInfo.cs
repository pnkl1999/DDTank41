using System;
using System.Collections.Generic;

namespace Game.Server.ConsortiaTask.Data
{
    public class ConsortiaTaskInfo
    {
        public int ID
        {
            get;
            set;
        }
        /// <summary>
        /// Опыт
        /// </summary>
        public int Expirience
        {
            get;
            set;
        }
        /// <summary>
        /// Слава
        /// </summary>
        public int Offer
        {
            get;
            set;
        }
        /// <summary>
        /// Вклад
        /// </summary>
        public int Contribution
        {
            get;
            set;
        }
        /// <summary>
        /// Казна
        /// </summary>
        public int Riches
        {
            get;
            set;
        }
        /// <summary>
        /// Бафф
        /// </summary>
        public int BuffID
        {
            get;
            set;
        }
        /// <summary>
        /// Время начала ЗГ
        /// </summary>
        public DateTime BeginTime
        {
            get;
            set;
        }
        /// <summary>
        /// Когда началось ЗГ
        /// </summary>
        public int Time
        {
            get;
            set;
        }
        /// <summary>
        /// Уровень задания... до 5ур.
        /// </summary>
        public int Level
        {
            get;
            set;
        }

        public int Points
        {
            get;
            set;
        }

        public bool Completed
        {
            get;
            set;
        }
        public List<ConsortiaTaskConditionInfo> Conditions
        {
            get;
            set;
        }
    }
}
