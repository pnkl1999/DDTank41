namespace SqlDataProvider.Data
{
    public class PetSkillInfo
    {
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

        public int Turn { get; set; }

        public int Damage { get; set; }

        public int DamageCrit { get; set; }

        public void Clone(PetSkillInfo _clone)
        {
			ID = _clone.ID;
			Name = _clone.Name;
			ElementIDs = _clone.ElementIDs;
			Description = _clone.Description;
			BallType = _clone.BallType;
			NewBallID = _clone.NewBallID;
			CostMP = _clone.CostMP;
			Pic = _clone.Pic;
			Action = _clone.Action;
			EffectPic = _clone.EffectPic;
			Delay = _clone.Delay;
			ColdDown = _clone.ColdDown;
			GameType = _clone.GameType;
			Probability = _clone.Probability;
			Turn = _clone.Turn;
        }
    }
}
