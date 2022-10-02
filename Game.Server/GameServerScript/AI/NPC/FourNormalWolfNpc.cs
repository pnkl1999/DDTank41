using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic.Effects;
using Game.Logic;
using Game.Logic.Actions;
using Bussiness;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FourNormalWolfNpc : ABrain
    {
        private Player m_targetPlayer = null;

        private int friendlyNpcId = 4105;

        private SimpleBoss friendBoss = null;

        private bool OpenEye = false;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

            if (OpenEye)
                Body.Config.IsShield = true;
            else
                Body.Config.IsShield = false;
        }

        public override void OnCreated()
        {
            base.OnCreated();
            if(friendBoss == null)
            {
                // create friend bosss
                foreach(SimpleBoss boss in Game.FindLivingTurnBossWithID(friendlyNpcId))
                {
                    friendBoss = boss;
                    break;
                }
            }
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            // check xem mo mat chua
            if ((int)friendBoss.Properties1 == 0 && OpenEye == true)
            {
                // change state B -> A
                Body.PlayMovie("BtoA", 1000, 4000);
                Body.CallFuction(new LivingCallBack(RemoveTargetPlayer), 5000);
                OpenEye = false;
            }
            else if ((int)friendBoss.Properties1 == 1 && OpenEye == false)
            {
                Body.PlayMovie("AtoB", 2000, 4000);
                Body.CallFuction(new LivingCallBack(FindRandomPlayer), 4000);
                OpenEye = true;
            }
            else if (OpenEye == true && m_targetPlayer != null)
            {
                int rand = Game.Random.Next(100);
                if (rand < 50 && Body.Distance(m_targetPlayer.X, m_targetPlayer.Y) > 600)
                {
                    // jump to target
                    JumpToTargetPlayer();
                }
                else
                {
                    RunToTargetPlayer();
                }
            }
            else if (OpenEye == false)
            {
                RandomMove();
            }
            else
            {
                Console.WriteLine("eye: " + OpenEye + " - friendBoss.Properties1: " + friendBoss.Properties1);
            }
        }

        private void RandomMove()
        {
            Body.ChangeDirection(-1, 1200);
            Body.ChangeDirection(1, 1800);
            Body.ChangeDirection(-1, 2300);
            int dismove = Game.Random.Next(-300, 300);
            Body.MoveTo(Body.X + dismove, Body.Y, "walkA", 3500, 3, NothingAction);
        }

        private void NothingAction()
        {
            Body.ChangeDirection(1, 500);
            Body.ChangeDirection(-1, 1000);
            Body.PlayMovie("beatA", 1000, 2000, SetState);
        }

        private void FindRandomPlayer()
        {
            m_targetPlayer = Game.FindRandomPlayer();

            if(m_targetPlayer != null)
            {
                Body.ChangeDirection(m_targetPlayer, 500);
                // notice player
                ((PVEGame)Game).SendPlayersPicture(m_targetPlayer, (int)BuffType.Targeting, true);
                Body.Say("Lo chạy đi <p class=\"red\">" + m_targetPlayer.PlayerDetail.PlayerCharacter.NickName + "</p>Ta đến đây...", 0, 2000, 0);
                Body.CallFuction(SetState, 5000);
            }
        }

        private void RemoveTargetPlayer()
        {
            if (m_targetPlayer != null)
            {
                ((PVEGame)Game).SendPlayersPicture(m_targetPlayer, (int)BuffType.Targeting, false);
                m_targetPlayer = null;
            }
            Body.CallFuction(SetState, 1000);
        }
        private void RunToTargetPlayer()
        {
            Body.ChangeDirection(m_targetPlayer, 200);

            double dis = Body.Distance(m_targetPlayer.X, m_targetPlayer.Y);

            if(dis > 600)
                Body.MoveTo(m_targetPlayer.X, m_targetPlayer.Y, "walkB", 2200, 10, BeatTargetPlayer);
            else
                Body.MoveTo(m_targetPlayer.X, m_targetPlayer.Y, "walkC", 2200, 5, BeatTargetPlayer);
        }

        private void JumpToTargetPlayer()
        {
            Body.ChangeDirection(m_targetPlayer, 200);
            
            Body.PlayMovie("jump", 2000, 0);

            ((PVEGame)Game).SendObjectFocus(m_targetPlayer, 1, 5000, 0);

            Body.BoltMove(m_targetPlayer.X, m_targetPlayer.Y, 6000);

            Body.PlayMovie("fall", 7000, 0);

            Body.RangeAttacking(m_targetPlayer.X - 100, m_targetPlayer.X + 100, "cry", 8000, null);

            Body.CallFuction(new LivingCallBack(BeatTargetPlayer), 8500);
        }

        private void BeatTargetPlayer()
        {
            Body.CurrentDamagePlus = 2f;
            Body.Beat(m_targetPlayer, "beatB", 0, 0, 0); //1000
            Body.CallFuction(new LivingCallBack(SetState), 4000);
        }

        public override void OnBeforeTakedDamage(Living source, ref int damage, ref int crit)
        {
            if (OpenEye == false)
            {
                if (damage > 0 || crit > 0)
                    friendBoss.TakeDamage(source, ref damage, ref crit, "");
            }
            base.OnBeforeTakedDamage(source, ref damage, ref crit);
        }

        private void SetState()
        {
            if (OpenEye)
            {
                //Body.PlayMovie("standB", 0, 0);
                ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standB");
            }
            else
            {
                //Body.PlayMovie("standA", 0, 0);
                ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standA");
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
