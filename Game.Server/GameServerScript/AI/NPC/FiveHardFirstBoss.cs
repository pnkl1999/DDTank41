using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class FiveHardFirstBoss : ABrain
    {
        private int m_attackTurn = 0;

        private SimpleNpc m_friendNpc;

        protected Player m_targer;

        private List<PhysicalObj> phyObjects = new List<PhysicalObj>();

        private int m_state = 0;

        private int m_bossId = 5201;

        private int m_npcId = 5202;

        private int m_reduceStreng = 100;

        private int m_reduceBlood = 400;

        private static string[] AttackChat = new string[] {
                    ""
                };
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
            if (m_friendNpc == null)
            {
                SimpleNpc[] npcs = ((PVEGame)Game).GetNPCLivingWithID(m_npcId);
                if (npcs.Length > 0)
                    m_friendNpc = npcs[0];
            }
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            SetSpecialEffect();

            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
            m_state = 0;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            m_attackTurn++;
            // check can kill player
            List<Player> pneedkill = new List<Player>();

            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving && p.X > 1199)
                    pneedkill.Add(p);
                else if (p.IsLiving && p.X < 290 && p.Y < 555)
                    pneedkill.Add(p);
            }

            if (pneedkill.Count > 0)
            {
                DirectKill(pneedkill);
                return;
            }

            switch (m_state)
            {
                case 0:
                    BeatToA();
                    break;
                case 1:
                    BeatToB();
                    break;
                case 2:
                    BeatToC();
                    break;
                case 3:
                    BeatToD();
                    break;
                case 4:
                    // check if living dead
                    if (m_friendNpc.IsLiving)
                    {
                        BeatToE();
                    }
                    else
                    {
                        FallFromD();
                    }
                    break;
                case 5:
                    // check if living dead
                    if (m_friendNpc.IsLiving)
                    {
                        CreateShootBeatE();
                    }
                    else
                    {
                        FallFromE();
                    }
                    break;
            }
        }

        private void DirectKill(List<Player> players)
        {
            Body.CurrentDamagePlus = 1000f;
            foreach (Player p in players)
            {
                Body.BeatDirect(p, "", 2000, 1, 1);
            }
        }

        private void BeatToA()
        {
            m_state = 1;
            Body.PlayMovie("beatA", 1000, 10000);
            Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 10000, false);
            Body.CallFuction(new LivingCallBack(CreateEffectBeatA), 10000);
        }

        private void BeatToB()
        {
            m_state = 2;
            NpcWalkEffect();
            m_targer = Game.FindRandomPlayer();
            if (Body.ShootPoint(m_targer.X, m_targer.Y, 56, 1000, 10000, 1, 1.5f, 8000))
            {
                Body.PlayMovie("beatB", 1000, 10000);
            }
        }

        private void BeatToC()
        {
            //tia tim bi mat
            m_state = 3;
            NpcWalkEffect();
            Body.CurrentDamagePlus = 1.2f;
            Body.PlayMovie("beatC", 1000, 11000);
            //Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 9000, false);
            int rand = Game.Random.Next(50);
            if (rand < 50)
                Body.CallFuction(new LivingCallBack(CreateEffectBeatSpecialC), 9000);
            else
                Body.CallFuction(new LivingCallBack(CreateEffectBeatC), 9000);
        }

        private void BeatToD()
        {
            m_state = 4;
            Body.CurrentDamagePlus = 1.5f;

            //Console.WriteLine("go to state 4: " + m_friendNpc.IsLiving + " - " + m_friendNpc.ModelId);

            ((PVEGame)Game).SendObjectFocus(m_friendNpc, 1, 1000, 500);

            ((PVEGame)Game).SendLivingActionMapping(m_friendNpc, "stand", "standB");
            m_friendNpc.PlayMovie("AtoB", 2000, 0);
            m_friendNpc.PlayMovie("walkB", 6000, 0);
            m_friendNpc.Config.CanTakeDamage = true;

            ((PVEGame)Game).SendObjectFocus(Body, 1, 9000, 500);

            Body.PlayMovie("beatD", 10000, 10000);
            Body.CallFuction(new LivingCallBack(CreateEffectBeatD), 18000);
        }

        private void BeatToE()
        {
            m_state = 5;
            NpcWalkEffect();
            Body.PlayMovie("DtoE", 1000, 8000);
            Body.CallFuction(new LivingCallBack(CreateShootBeatE), 8000);
        }

        private void FallFromD()
        {
            m_state = 0;
            SetSpecialEffect();
            Body.PlayMovie("fallingA", 800, 3000);
            ((PVEGame)Game).SendFreeFocus(1441, 681, 1, 1000, 0);
            Body.CallFuction(new LivingCallBack(CallNewNpc), 3000);
        }

        private void FallFromE()
        {
            m_state = 0;
            SetSpecialEffect();
            Body.PlayMovie("fallingB", 800, 3000);
            ((PVEGame)Game).SendFreeFocus(1441, 681, 1, 1000, 0);
            Body.CallFuction(new LivingCallBack(CallNewNpc), 3000);
        }

        private void CallNewNpc()
        {
            LivingConfig config = ((PVEGame)Game).BaseConfig();
            config.HasTurn = false;
            config.CanTakeDamage = false;

            SimpleNpc newNpc = ((PVEGame)Game).CreateNpc(m_npcId, m_friendNpc.X, m_friendNpc.Y, 1, 1, config);
            Game.RemoveLiving(m_friendNpc.Id);
            m_friendNpc = newNpc;

            ((PVEGame)Game).SendLivingActionMapping(m_friendNpc, "stand", "standA");
            ((PVEGame)Game).SendObjectFocus(m_friendNpc, 1, 2000, 0);
            m_friendNpc.PlayMovie("in", 3000, 10000);
            Body.CallFuction(new LivingCallBack(NpcWalkEffect), 11000);

            ((PVEGame)Game).SendObjectFocus(Body, 1, 14000, 500);
            Body.CallFuction(new LivingCallBack(BeatToA), 15000);
        }

        private void NpcWalkEffect()
        {
            if (m_friendNpc.Config.CanTakeDamage)
                m_friendNpc.PlayMovie("walkB", 1000, 3000);
            else
                m_friendNpc.PlayMovie("walkA", 1000, 3000);
        }

        private void CreateShootBeatE()
        {
            SetSpecialEffect();
            Body.CurrentDamagePlus = 3f;
            m_targer = Game.FindRandomPlayer();
            if (Body.ShootPoint(m_targer.X - 20, m_targer.Y, 72, 1000, 10000, 1, 0.1f, 3300))
            {
                Body.PlayMovie("beatE", 1000, 0);
            }
        }

        private void CreateEffectBeatD()
        {
            //Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 400, false);
            //Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 500, false);
            //Body.RangeAttacking(Body.X - 10000, Body.X + 10000, "cry", 600, false);

            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving)
                {
                    phyObjects.Add(((PVEGame)Game).Createlayer(p.X, p.Y, "", "asset.game.4.minigun", "", 1, 1));
                    p.AddEffect(new ReduceStrengthEffect(2, m_reduceStreng), 1000);
                    Body.BeatDirect(p, "", 1000, 3, 1);
                }
            }
        }

        private void CreateEffectBeatC()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving)
                {
                    phyObjects.Add(((PVEGame)Game).Createlayer(p.X, p.Y - 10, "", "asset.game.4.zap", "", 1, 1));
                    p.AddEffect(new ReduceStrengthEffect(2, m_reduceStreng), 1000);
                    Body.BeatDirect(p, "", 1000, 3, 1);
                }
            }
        }

        private void CreateEffectBeatSpecialC()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving)
                {
                    phyObjects.Add(((PVEGame)Game).Createlayer(p.X, p.Y - 10, "", "asset.game.4.zap2", "", 1, 1));
                    p.AddEffect(new ReduceStrengthEffect(2, m_reduceStreng), 1000);
                    Body.BeatDirect(p, "", 1000, 4, 1);
                }
            }
        }

        private void CreateEffectBeatA()
        {
            foreach (Player p in Game.GetAllLivingPlayers())
            {
                if (p.IsLiving)
                {
                    p.AddEffect(new ContinueReduceBloodEffect(2, m_reduceBlood, Body), 500);
                }
            }
        }

        public override void OnDie()
        {
            base.OnDie();
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        public override void OnBeforeTakedDamage(Living source, ref int damageAmount, ref int criticalAmount)
        {
            base.OnBeforeTakedDamage(source, ref damageAmount, ref criticalAmount);
        }

        private void SetSpecialEffect()
        {
            switch (m_state)
            {
                case 1:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cryA");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "die", "dieA");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standA");
                    Body.SetOffsetY(-75);
                    Body.SetRect(-110, -144, 230, 149);
                    Body.SetRelateDemagemRect(-110, -144, 230, 149);
                    break;
                case 2:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cryB");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "die", "dieB");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standB");
                    Body.SetOffsetY(-150);
                    Body.FireY = -268;
                    Body.SetRect(-110, -268, 230, 149);
                    Body.SetRelateDemagemRect(-110, -268, 230, 149);
                    break;
                case 3:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cryC");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "die", "dieC");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standC");
                    Body.SetOffsetY(-225);
                    Body.SetRect(-110, -391, 230, 149);
                    Body.SetRelateDemagemRect(-110, -391, 230, 149);
                    break;
                case 4:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cryD");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "die", "dieD");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standD");
                    Body.SetOffsetY(-300);
                    Body.SetRect(-110, -500, 230, 149);
                    Body.SetRelateDemagemRect(-110, -500, 230, 149);
                    break;
                case 5:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cryE");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "die", "dieE");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "standE");
                    Body.SetOffsetY(-420);
                    Body.FireX = -120;
                    Body.FireY = -500;
                    Body.SetRect(-110, -630, 230, 149);
                    Body.SetRelateDemagemRect(-110, -630, 230, 149);
                    break;
                default:
                    ((PVEGame)Game).SendLivingActionMapping(Body, "cry", "cry");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "die", "die");
                    ((PVEGame)Game).SendLivingActionMapping(Body, "stand", "stand");
                    Body.FireX = ((SimpleBoss)Body).NpcInfo.FireX;
                    Body.FireY = ((SimpleBoss)Body).NpcInfo.FireY;
                    break;
            }
        }

    }
}
