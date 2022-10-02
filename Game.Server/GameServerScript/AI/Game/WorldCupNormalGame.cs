using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;

namespace Game.Server.GameServerScript.AI.Game
{
    public class WorldCupNormalGame : APVEGameControl
    {
        public override void OnCreated()
        {
            Game.SetupMissions("14101,14102,14103");
            Game.TotalMissionCount = 3;
        }

        public override void OnPrepated()
        {

        }

        public override int CalculateScoreGrade(int score)
        {
            if(score > 800)
            {
                return 3;
            }
            else if(score > 725)
            {
                return 2;
            }
            else if(score > 650)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public override void OnGameOverAllSession()
        {
        }
    }
}
