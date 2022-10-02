using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SqlDataProvider.Data
{
    public class MountSkillTemplateInfo
    {
        public void Clone(MountSkillTemplateInfo temp)
        {
            ID = temp.ID;
            Name = temp.Name;
            ElementIDs = temp.ElementIDs;
            Description = temp.Description;
            BallType = temp.BallType;
            NewBallID = temp.NewBallID;
            CostMP = temp.CostMP;
            Pic = temp.Pic;
            Action = temp.Action;
            EffectPic = temp.EffectPic;
            Delay = temp.Delay;
            ColdDown = temp.ColdDown;
            GameType = temp.GameType;
            Probability = temp.Probability;
            CostEnergy = temp.CostEnergy;
            UseCount = temp.UseCount;
            Count = temp.Count;
            Turn = temp.Turn;
        }
        public int ID { get; set; }
        public string Name { get; set; }
        public string ElementIDs { get; set; }
        public string Description { get; set; }
        public int BallType { get; set; }
        public int NewBallID { get; set; }
        public int CostMP { get; set; }
        public int Pic { get; set; }
        public string Action { get; set; }
        public string EffectPic { get; set; }
        public int Delay { get; set; }
        public int ColdDown { get; set; }
        public int GameType { get; set; }
        public int Probability { get; set; }
        public int CostEnergy { get; set; }
        public int UseCount { get; set; }
        public int Count { get; set; }
        public int Turn { get; set; }
    }
}
