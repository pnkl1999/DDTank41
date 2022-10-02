using Game.Base.Packets;
using Game.Logic.PetEffects.ContinueElement;
using Game.Logic.Phy.Object;
using System;
using System.Collections.Generic;
using System.Drawing;

namespace Game.Logic.PetEffects.Element.Actives
{
    public class AE1436 : BasePetEffect
    {
        private int m_type = 0;
        private int m_count = 0;
        private int m_probability = 0;
        private int m_delay = 0;
        private int m_coldDown = 0;
        private int m_currentId;
        private int m_added = 0;
        private int m_fx;
        private int m_tx;
        private int BaseDistant = 500;

        public AE1436(int count, int probability, int type, int skillId, int delay, string elementID)
            : base(ePetEffectType.AE1436, elementID)
        {
            m_count = count;
            m_coldDown = count;
            m_probability = probability == -1 ? 10000 : probability;
            m_type = type;
            m_delay = delay;
            m_currentId = skillId;
        }

        public override bool Start(Living living)
        {
            AE1436 effect = living.PetEffectList.GetOfType(ePetEffectType.AE1436) as AE1436;
            if (effect != null)
            {
                effect.m_probability = m_probability > effect.m_probability ? m_probability : effect.m_probability;
                return true;
            }
            else
            {
                return base.Start(living);
            }
        }

        protected override void OnAttachedToPlayer(Player player)
        {
            player.PlayerBuffSkillPet += new PlayerEventHandle(player_AfterBuffSkillPetByLiving);
        }

        protected override void OnRemovedFromPlayer(Player player)
        {
            player.PlayerBuffSkillPet -= new PlayerEventHandle(player_AfterBuffSkillPetByLiving);
        }

        void player_AfterBuffSkillPetByLiving(Player player)
        {
            if (player.PetEffects.CurrentUseSkill == m_currentId)
            {
                int tem_fx = m_living.X - BaseDistant;
                int tem_tx = m_living.X + BaseDistant;
                int maxWidth = m_living.Game.Map.Info.BackroundWidht;

                m_fx = tem_fx <= 0 ? 0 : tem_fx;
                m_tx = tem_tx >= maxWidth ? maxWidth : tem_tx;
                if (m_fx == 0)
                {
                    m_tx += Math.Abs(tem_fx);
                }
                if (m_tx == maxWidth)
                {
                    m_fx -= Math.Abs(tem_tx - maxWidth);
                }

                List<Living> playersAround = new List<Living>();
                if (m_living.Game is PVPGame)
                {
                    List<Player> enemies = m_living.Game.GetAllEnemyPlayers(m_living);
                    playersAround = m_living.Game.Map.FindRandomPlayer(m_fx, m_tx, enemies);
                }
                else
                {
                    playersAround = m_living.Game.Map.FindRandomLiving(m_fx, m_tx);
                }
                int count = playersAround.Count;
                for (int i = 0; i < 5; i++)
                {
                    GSPacketIn pkg = new GSPacketIn((byte)ePackageTypeLogic.GAME_CMD, m_living.Id);
                    pkg.Parameter1 = m_living.Id;
                    pkg.WriteByte((byte)eTankCmdType.LIVING_RANGEATTACKING);
                    pkg.WriteInt(count);
                    m_living.SyncAtTime = false;
                    try
                    {
                        foreach (Living p in playersAround)
                        {
                            int dander = 0;
                            p.SyncAtTime = false;
                            p.IsFrost = false;
                            p.IsHide = false;
                            player.Game.SendGameUpdateFrozenState(p);
                            player.Game.SendGameUpdateHideState(p);
                            int damage = MakeDamage(p);
                            int critical = MakeCriticalDamage(p, damage);
                            int totalDemageAmount = 0;
                            if (p is Player)
                            {
                                p.OnTakedDamage(p, ref damage, ref critical);
                            }
                            if (p.TakeDamage(m_living, ref damage, ref critical, "范围攻击"))
                            {
                                totalDemageAmount = damage + critical;
                                if (p is Player)
                                {
                                    dander = (p as Player).Dander;
                                }
                            }
                            pkg.WriteInt(p.Id);
                            pkg.WriteInt(totalDemageAmount);
                            pkg.WriteInt(p.Blood);
                            pkg.WriteInt(dander);
                            pkg.WriteInt(1);//updateBlood                            
                        }
                        player.Game.SendToAll(pkg);
                    }
                    finally
                    {
                        m_living.SyncAtTime = true;
                        foreach (Living p in playersAround)
                        {
                            p.SyncAtTime = true;
                        }
                    }
                    //Console.WriteLine("Buff Name: {2}, ID: {0}, player.CurrentDamagePlus: {1}", ElementInfo.ID, player.CurrentDamagePlus, ElementInfo.Name);
                }
                foreach (Living p in playersAround)
                {
                    if (!p.IsLiving && m_currentId == 376)
                    {
                        List<Player> allies = m_living.Game.GetAllTeamPlayers(m_living);
                        foreach (Player ally in allies)
                        {
                            ally.SyncAtTime = true;
                            ally.AddBlood((ally.MaxBlood * 15 / 100));
                            ally.SyncAtTime = false;
                        }
                    }
                }
            }
        }

        private int MakeDamage(Living p)
        {
            double baseDamage = m_living.BaseDamage;
            double baseGuard = p.BaseGuard;
            double defence = p.Defence;//+ p.MagicDefence;
            double attack = m_living.Attack;//+ m_living.MagicAttack;

            if (p.AddArmor && (p as Player).DeputyWeapon != null)
            {
                int addPoint = (p as Player).DeputyWeapon.Template.Property7 + (int)Math.Pow(1.1, (double)(p as Player).DeputyWeapon.StrengthenLevel);
                baseGuard += addPoint;
                defence += addPoint;
            }
            if (m_living.IgnoreArmor)
            {
                baseGuard = 0;
                defence = 0;
            }

            float damagePlus = m_living.CurrentDamagePlus;
            float shootMinus = m_living.CurrentShootMinus;


            double DR1 = 0.95 * (baseGuard - 3 * m_living.Grade) / (500 + baseGuard - 3 * m_living.Grade);//护甲提供伤害减免
            double DR2 = 0;
            if ((defence - m_living.Lucky) < 0)
            {
                DR2 = 0;
            }
            else
            {
                DR2 = 0.95 * (defence - m_living.Lucky) / (600 + defence - m_living.Lucky); //防御提供的伤害减免
            }
            //DR2 = DR2 < 0 ? 0 : DR2;

            double damage = (baseDamage * (1 + attack * 0.001) * (1 - (DR1 + DR2 - DR1 * DR2))) * damagePlus * shootMinus;

            Rectangle rect = p.GetDirectDemageRect();
            double distance = Math.Sqrt((rect.X - m_living.X) * (rect.X - m_living.X) + (rect.Y - m_living.Y) * (rect.Y - m_living.Y));
            damage = damage * (1 - distance / Math.Abs(m_tx - m_fx) / 4);

            if (damage < 0)
            {
                return 1;
            }
            else
            {
                return (int)damage;
            }
        }

        private int MakeCriticalDamage(Living p, int baseDamage)
        {
            double lucky = m_living.Lucky;

            Random rd = new Random();
            bool canHit = 75000 * lucky / (lucky + 800) > rd.Next(100000);
            if (canHit)
            {
                int totalReduceCrit = p.ReduceCritFisrtGem + p.ReduceCritSecondGem;
                int CritDamage = (int)((0.5 + lucky * 0.0003) * baseDamage);
                CritDamage = CritDamage * (100 - totalReduceCrit) / 100;
                return CritDamage;
            }
            else
            {
                return 0;
            }
        }

    }
}
