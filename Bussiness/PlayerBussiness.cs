using Bussiness.CenterService;
using Bussiness.Managers;
using Newtonsoft.Json;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Bussiness
{
    public class PlayerBussiness : BaseBussiness
    {
        public bool ActivePlayer(ref PlayerInfo player, string userName, string passWord, bool sex, int gold, int money, string IP, string site)
        {
            bool flag = false;
            try
            {
                player = new PlayerInfo();
                player.Agility = 0;
                player.Attack = 0;
                player.Colors = ",,,,,,";
                player.Skin = "";
                player.ConsortiaID = 0;
                player.Defence = 0;
                player.Gold = 0;
                player.GP = 1;
                player.Grade = 1;
                player.ID = 0;
                player.Luck = 0;
                player.Money = 0;
                player.NickName = "";
                player.Sex = sex;
                player.State = 0;
                player.Style = ",,,,,,";
                player.Hide = 1111111111;
                SqlParameter[] sqlParameters = new SqlParameter[21];
                sqlParameters[0] = new SqlParameter("@UserID", SqlDbType.Int);
                sqlParameters[0].Direction = ParameterDirection.Output;
                sqlParameters[1] = new SqlParameter("@Attack", player.Attack);
                sqlParameters[2] = new SqlParameter("@Colors", (player.Colors == null) ? "" : player.Colors);
                sqlParameters[3] = new SqlParameter("@ConsortiaID", player.ConsortiaID);
                sqlParameters[4] = new SqlParameter("@Defence", player.Defence);
                sqlParameters[5] = new SqlParameter("@Gold", player.Gold);
                sqlParameters[6] = new SqlParameter("@GP", player.GP);
                sqlParameters[7] = new SqlParameter("@Grade", player.Grade);
                sqlParameters[8] = new SqlParameter("@Luck", player.Luck);
                sqlParameters[9] = new SqlParameter("@Money", player.Money);
                sqlParameters[10] = new SqlParameter("@Style", (player.Style == null) ? "" : player.Style);
                sqlParameters[11] = new SqlParameter("@Agility", player.Agility);
                sqlParameters[12] = new SqlParameter("@State", player.State);
                sqlParameters[13] = new SqlParameter("@UserName", userName);
                sqlParameters[14] = new SqlParameter("@PassWord", passWord);
                sqlParameters[15] = new SqlParameter("@Sex", sex);
                sqlParameters[16] = new SqlParameter("@Hide", player.Hide);
                sqlParameters[17] = new SqlParameter("@ActiveIP", IP);
                sqlParameters[18] = new SqlParameter("@Skin", (player.Skin == null) ? "" : player.Skin);
                sqlParameters[19] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[19].Direction = ParameterDirection.ReturnValue;
                sqlParameters[20] = new SqlParameter("@Site", site);
                flag = db.RunProcedure("SP_Users_Active", sqlParameters);
                player.ID = (int)sqlParameters[0].Value;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DeleteQuestUser(int UserID, int QuestID)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[]
                {
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@QuestID", QuestID)
                };
                result = this.db.RunProcedure("SP_Users_Quest_Delete", para);
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            return result;
        }

        public bool AddAuction(AuctionInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[18]
                {
                    new SqlParameter("@AuctionID", info.AuctionID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                sqlParameters[0].Direction = ParameterDirection.Output;
                sqlParameters[1] = new SqlParameter("@AuctioneerID", info.AuctioneerID);
                sqlParameters[2] = new SqlParameter("@AuctioneerName", (info.AuctioneerName == null) ? "" : info.AuctioneerName);
                sqlParameters[3] = new SqlParameter("@BeginDate", info.BeginDate);
                sqlParameters[4] = new SqlParameter("@BuyerID", info.BuyerID);
                sqlParameters[5] = new SqlParameter("@BuyerName", (info.BuyerName == null) ? "" : info.BuyerName);
                sqlParameters[6] = new SqlParameter("@IsExist", info.IsExist);
                sqlParameters[7] = new SqlParameter("@ItemID", info.ItemID);
                sqlParameters[8] = new SqlParameter("@Mouthful", info.Mouthful);
                sqlParameters[9] = new SqlParameter("@PayType", info.PayType);
                sqlParameters[10] = new SqlParameter("@Price", info.Price);
                sqlParameters[11] = new SqlParameter("@Rise", info.Rise);
                sqlParameters[12] = new SqlParameter("@ValidDate", info.ValidDate);
                sqlParameters[13] = new SqlParameter("@TemplateID", info.TemplateID);
                sqlParameters[14] = new SqlParameter("Name", info.Name);
                sqlParameters[15] = new SqlParameter("Category", info.Category);
                sqlParameters[16] = new SqlParameter("Random", info.Random);
                sqlParameters[17] = new SqlParameter("goodsCount", info.goodsCount);
                flag = db.RunProcedure("SP_Auction_Add", sqlParameters);
                info.AuctionID = (int)sqlParameters[0].Value;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddCards(UsersCardInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[19]
                {
                    new SqlParameter("@CardID", item.CardID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@UserID", item.UserID);
                SqlParameters[2] = new SqlParameter("@TemplateID", item.TemplateID);
                SqlParameters[3] = new SqlParameter("@Place", item.Place);
                SqlParameters[4] = new SqlParameter("@Count", item.Count);
                SqlParameters[5] = new SqlParameter("@Attack", item.Attack);
                SqlParameters[6] = new SqlParameter("@Defence", item.Defence);
                SqlParameters[7] = new SqlParameter("@Agility", item.Agility);
                SqlParameters[8] = new SqlParameter("@Luck", item.Luck);
                SqlParameters[9] = new SqlParameter("@Guard", item.Guard);
                SqlParameters[10] = new SqlParameter("@Damage", item.Damage);
                SqlParameters[11] = new SqlParameter("@Level", item.Level);
                SqlParameters[12] = new SqlParameter("@CardGP", item.CardGP);
                SqlParameters[14] = new SqlParameter("@isFirstGet", item.isFirstGet);
                SqlParameters[15] = new SqlParameter("@AttackReset", item.AttackReset);
                SqlParameters[16] = new SqlParameter("@DefenceReset", item.DefenceReset);
                SqlParameters[17] = new SqlParameter("@AgilityReset", item.AgilityReset);
                SqlParameters[18] = new SqlParameter("@LuckReset", item.LuckReset);
                SqlParameters[13] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[13].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UserCard_Add", SqlParameters);
                flag = (int)SqlParameters[13].Value == 0;
                item.CardID = (int)SqlParameters[0].Value;
                item.IsDirty = false;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddChargeMoney(string chargeID, string userName, int money, string payWay, decimal needMoney, ref int userID, ref int isResult, DateTime date, string IP, string nickName)
        {
            bool flag = false;
            userID = 0;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[10]
                {
                    new SqlParameter("@ChargeID", chargeID),
                    new SqlParameter("@UserName", userName),
                    new SqlParameter("@Money", money),
                    new SqlParameter("@Date", date.ToString("yyyy-MM-dd HH:mm:ss")),
                    new SqlParameter("@PayWay", payWay),
                    new SqlParameter("@NeedMoney", needMoney),
                    new SqlParameter("@UserID", userID),
                    null,
                    null,
                    null
                };
                sqlParameters[6].Direction = ParameterDirection.InputOutput;
                sqlParameters[7] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[7].Direction = ParameterDirection.ReturnValue;
                sqlParameters[8] = new SqlParameter("@IP", IP);
                sqlParameters[9] = new SqlParameter("@NickName", nickName);
                flag = db.RunProcedure("SP_Charge_Money_Add", sqlParameters);
                userID = (int)sqlParameters[6].Value;
                isResult = (int)sqlParameters[7].Value;
                flag = isResult == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddChargeMoney(string chargeID, string userName, int money, string payWay, decimal needMoney, ref int userID, ref int isResult, DateTime date, string IP, int UserID)
        {
            bool flag = false;
            userID = 0;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[10]
                {
                    new SqlParameter("@ChargeID", chargeID),
                    new SqlParameter("@UserName", userName),
                    new SqlParameter("@Money", money),
                    new SqlParameter("@Date", date.ToString("yyyy-MM-dd HH:mm:ss")),
                    new SqlParameter("@PayWay", payWay),
                    new SqlParameter("@NeedMoney", needMoney),
                    new SqlParameter("@UserID", userID),
                    null,
                    null,
                    null
                };
                sqlParameters[6].Direction = ParameterDirection.InputOutput;
                sqlParameters[7] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[7].Direction = ParameterDirection.ReturnValue;
                sqlParameters[8] = new SqlParameter("@IP", IP);
                sqlParameters[9] = new SqlParameter("@SourceUserID", UserID);
                flag = db.RunProcedure("SP_Charge_Money_UserId_Add", sqlParameters);
                userID = (int)sqlParameters[6].Value;
                isResult = (int)sqlParameters[7].Value;
                flag = isResult == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddFriends(FriendInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[7]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@AddDate", DateTime.Now),
                    new SqlParameter("@FriendID", info.FriendID),
                    new SqlParameter("@IsExist", true),
                    new SqlParameter("@Remark", (info.Remark == null) ? "" : info.Remark),
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@Relation", info.Relation)
                };
                flag = db.RunProcedure("SP_Users_Friends_Add", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddGoods(ItemInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[39];
                para[0] = new SqlParameter("@ItemID", item.ItemID);
                para[0].Direction = ParameterDirection.Output;
                para[1] = new SqlParameter("@UserID", item.UserID);
                para[2] = new SqlParameter("@TemplateID", item.Template.TemplateID);
                para[3] = new SqlParameter("@Place", item.Place);
                para[4] = new SqlParameter("@AgilityCompose", item.AgilityCompose);
                para[5] = new SqlParameter("@AttackCompose", item.AttackCompose);
                para[6] = new SqlParameter("@BeginDate", item.BeginDate);
                para[7] = new SqlParameter("@Color", item.Color == null ? "" : item.Color);
                para[8] = new SqlParameter("@Count", item.Count);
                para[9] = new SqlParameter("@DefendCompose", item.DefendCompose);
                para[10] = new SqlParameter("@IsBinds", item.IsBinds);
                para[11] = new SqlParameter("@IsExist", item.IsExist);
                para[12] = new SqlParameter("@IsJudge", item.IsJudge);
                para[13] = new SqlParameter("@LuckCompose", item.LuckCompose);
                para[14] = new SqlParameter("@StrengthenLevel", item.StrengthenLevel);
                para[15] = new SqlParameter("@ValidDate", item.ValidDate);
                para[16] = new SqlParameter("@BagType", item.BagType);
                para[17] = new SqlParameter("@Skin", item.Skin == null ? "" : item.Skin);
                para[18] = new SqlParameter("@IsUsed", item.IsUsed);
                para[19] = new SqlParameter("@RemoveType", item.RemoveType);
                para[20] = new SqlParameter("@Hole1", item.Hole1);
                para[21] = new SqlParameter("@Hole2", item.Hole2);
                para[22] = new SqlParameter("@Hole3", item.Hole3);
                para[23] = new SqlParameter("@Hole4", item.Hole4);
                para[24] = new SqlParameter("@Hole5", item.Hole5);
                para[25] = new SqlParameter("@Hole6", item.Hole6);
                para[26] = new SqlParameter("@StrengthenTimes", item.StrengthenTimes);
                para[27] = new SqlParameter("@Hole5Level", item.Hole5Level);
                para[28] = new SqlParameter("@Hole5Exp", item.Hole5Exp);
                para[29] = new SqlParameter("@Hole6Level", item.Hole6Level);
                para[30] = new SqlParameter("@Hole6Exp", item.Hole6Exp);
                para[31] = new SqlParameter("@IsGold", item.IsGold);
                para[32] = new SqlParameter("@goldValidDate", item.goldValidDate);
                para[33] = new SqlParameter("@goldBeginTime", item.goldBeginTime);
                para[34] = new SqlParameter("@StrengthenExp", item.StrengthenExp);
                para[35] = new SqlParameter("@Blood", item.Blood);
                para[36] = new SqlParameter("@latentEnergyCurStr", item.latentEnergyCurStr);
                para[37] = new SqlParameter("@latentEnergyNewStr", item.latentEnergyNewStr);
                para[38] = new SqlParameter("@latentEnergyEndTime", item.latentEnergyEndTime);
                result = db.RunProcedure("SP_Users_Items_Add", para);
                item.ItemID = (int)para[0].Value;
                item.IsDirty = false;
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("Init item.goldBeginTime: " + item.goldBeginTime + " item.goldValidDate: " + item.goldValidDate, e);
                }

            }
            return result;
        }

        public bool AddMarryInfo(MarryInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[5]
                {
                    new SqlParameter("@ID", info.ID),
                    null,
                    null,
                    null,
                    null
                };
                sqlParameters[0].Direction = ParameterDirection.Output;
                sqlParameters[1] = new SqlParameter("@UserID", info.UserID);
                sqlParameters[2] = new SqlParameter("@IsPublishEquip", info.IsPublishEquip);
                sqlParameters[3] = new SqlParameter("@Introduction", info.Introduction);
                sqlParameters[4] = new SqlParameter("@RegistTime", info.RegistTime);
                flag = db.RunProcedure("SP_MarryInfo_Add", sqlParameters);
                info.ID = (int)sqlParameters[0].Value;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("AddMarryInfo", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddStore(ItemInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[14]
                {
                    new SqlParameter("@ItemID", item.ItemID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                sqlParameters[0].Direction = ParameterDirection.Output;
                sqlParameters[1] = new SqlParameter("@UserID", item.UserID);
                sqlParameters[2] = new SqlParameter("@TemplateID", item.Template.TemplateID);
                sqlParameters[3] = new SqlParameter("@Place", item.Place);
                sqlParameters[4] = new SqlParameter("@AgilityCompose", item.AgilityCompose);
                sqlParameters[5] = new SqlParameter("@AttackCompose", item.AttackCompose);
                sqlParameters[6] = new SqlParameter("@BeginDate", item.BeginDate);
                sqlParameters[7] = new SqlParameter("@Color", (item.Color == null) ? "" : item.Color);
                sqlParameters[8] = new SqlParameter("@Count", item.Count);
                sqlParameters[9] = new SqlParameter("@DefendCompose", item.DefendCompose);
                sqlParameters[10] = new SqlParameter("@IsBinds", item.IsBinds);
                sqlParameters[11] = new SqlParameter("@IsExist", item.IsExist);
                sqlParameters[12] = new SqlParameter("@IsJudge", item.IsJudge);
                sqlParameters[13] = new SqlParameter("@LuckCompose", item.LuckCompose);
                flag = db.RunProcedure("SP_Users_Items_Add", sqlParameters);
                item.ItemID = (int)sqlParameters[0].Value;
                item.IsDirty = false;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddUserMatchInfo(UserMatchInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[17];
                para[0] = new SqlParameter("@ID", info.ID);
                para[0].Direction = ParameterDirection.Output;
                para[1] = new SqlParameter("@UserID", info.UserID);
                para[2] = new SqlParameter("@dailyScore", info.dailyScore);
                para[3] = new SqlParameter("@dailyWinCount", info.dailyWinCount);
                para[4] = new SqlParameter("@dailyGameCount", info.dailyGameCount);
                para[5] = new SqlParameter("@DailyLeagueFirst", info.DailyLeagueFirst);
                para[6] = new SqlParameter("@DailyLeagueLastScore", info.DailyLeagueLastScore);
                para[7] = new SqlParameter("@weeklyScore", info.weeklyScore);
                para[8] = new SqlParameter("@weeklyGameCount", info.weeklyGameCount);
                para[9] = new SqlParameter("@weeklyRanking", info.weeklyRanking);
                para[10] = new SqlParameter("@addDayPrestge", info.addDayPrestge);
                para[11] = new SqlParameter("@totalPrestige", info.totalPrestige);
                para[12] = new SqlParameter("@restCount", info.restCount);
                para[13] = new SqlParameter("@leagueGrade", info.leagueGrade);
                para[14] = new SqlParameter("@leagueItemsGet", info.leagueItemsGet);
                para[16] = new SqlParameter("@WeeklyWinCount", info.WeeklyWinCount);
                para[15] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[15].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UserMatch_Add", para);
                result = (int)para[15].Value == 0;
                info.ID = (int)para[0].Value;
                info.IsDirty = false;

            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            finally
            {
            }
            return result;
        }

        public bool AddUserRank(UserRankInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[16];
                para[0] = new SqlParameter("@ID", item.ID);
                para[0].Direction = ParameterDirection.Output;
                para[1] = new SqlParameter("@UserID", item.UserID);
                para[2] = new SqlParameter("@UserRank", item.Name);
                para[3] = new SqlParameter("@Attack", item.Attack);
                para[4] = new SqlParameter("@Defence", item.Defence);
                para[5] = new SqlParameter("@Luck", item.Luck);
                para[6] = new SqlParameter("@Agility", item.Agility);
                para[7] = new SqlParameter("@HP", item.HP);
                para[8] = new SqlParameter("@Damage", item.Damage);
                para[9] = new SqlParameter("@Guard", item.Guard);
                para[10] = new SqlParameter("@BeginDate", item.BeginDate);
                para[11] = new SqlParameter("@Validate", item.Validate);
                para[12] = new SqlParameter("@IsExit", item.IsExit);
                para[13] = new SqlParameter("@Result", SqlDbType.Int);
                para[13].Direction = ParameterDirection.ReturnValue;
                para[14] = new SqlParameter("@NewTitleID", item.NewTitleID);
                para[15] = new SqlParameter("@EndDate", item.EndDate);
                db.RunProcedure("SP_UserRank_Add", para);
                result = (int)para[13].Value == 0;
                item.ID = (int)para[0].Value;
                item.IsDirty = false;

            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            return result;
        }

        public bool CancelPaymentMail(int userid, int mailID, ref int senderID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[4]
                {
                    new SqlParameter("@userid", userid),
                    new SqlParameter("@mailID", mailID),
                    new SqlParameter("@senderID", SqlDbType.Int),
                    null
                };
                sqlParameters[2].Value = senderID;
                sqlParameters[2].Direction = ParameterDirection.InputOutput;
                sqlParameters[3] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[3].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Mail_PaymentCancel", sqlParameters);
                flag = (int)sqlParameters[3].Value == 0;
                if (flag)
                {
                    senderID = (int)sqlParameters[2].Value;
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool ChargeToUser(string userName, ref int money, string nickName)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@UserName", userName),
                    new SqlParameter("@money", SqlDbType.Int),
                    null
                };
                sqlParameters[1].Direction = ParameterDirection.Output;
                sqlParameters[2] = new SqlParameter("@NickName", nickName);
                flag = db.RunProcedure("SP_Charge_To_User", sqlParameters);
                money = (int)sqlParameters[1].Value;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool CheckAccount(string username, string password)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Password", password),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_CheckAccount", sqlParameters);
                flag = (int)sqlParameters[2].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool CheckEmailIsValid(string Email)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@Email", Email),
                    new SqlParameter("@count", SqlDbType.BigInt)
                };
                sqlParameters[1].Direction = ParameterDirection.Output;
                db.RunProcedure("CheckEmailIsValid", sqlParameters);
                if (int.Parse(sqlParameters[1].Value.ToString()) == 0)
                {
                    flag = true;
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init CheckEmailIsValid", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DeleteAuction(int auctionID, int userID, ref string msg)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@AuctionID", auctionID),
                    new SqlParameter("@UserID", userID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Auction_Delete", SqlParameters);
                int num = (int)SqlParameters[2].Value;
                flag = num == 0;
                switch (num)
                {
                    case 0:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg1");
                        return flag;
                    case 1:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg2");
                        return flag;
                    case 2:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg3");
                        return flag;
                    default:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Msg4");
                        return flag;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool DeleteFriends(int UserID, int FriendID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@ID", FriendID),
                    new SqlParameter("@UserID", UserID)
                };
                flag = db.RunProcedure("SP_Users_Friends_Delete", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DeleteGoods(int itemID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ID", itemID)
                };
                flag = db.RunProcedure("SP_Users_Items_Delete", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DeleteMail(int UserID, int mailID, out int senderID)
        {
            bool flag = false;
            senderID = 0;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[4]
                {
                    new SqlParameter("@ID", mailID),
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@SenderID", SqlDbType.Int),
                    null
                };
                sqlParameters[2].Value = senderID;
                sqlParameters[2].Direction = ParameterDirection.InputOutput;
                sqlParameters[3] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[3].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Mail_Delete", sqlParameters);
                if ((int)sqlParameters[3].Value == 0)
                {
                    flag = true;
                    senderID = (int)sqlParameters[2].Value;
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DeleteMail2(int UserID, int mailID, out int senderID)
        {
            bool flag = false;
            senderID = 0;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[4]
                {
                    new SqlParameter("@ID", mailID),
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@SenderID", SqlDbType.Int),
                    null
                };
                sqlParameters[2].Value = senderID;
                sqlParameters[2].Direction = ParameterDirection.InputOutput;
                sqlParameters[3] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[3].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Mail_Delete", sqlParameters);
                if ((int)sqlParameters[3].Value == 0)
                {
                    flag = true;
                    senderID = (int)sqlParameters[2].Value;
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DeleteMarryInfo(int ID, int userID, ref string msg)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@ID", ID),
                    new SqlParameter("@UserID", userID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_MarryInfo_Delete", sqlParameters);
                int num = (int)sqlParameters[2].Value;
                flag = num == 0;
                if (num == 0)
                {
                    msg = LanguageMgr.GetTranslation("PlayerBussiness.DeleteAuction.Succeed");
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("DeleteAuction", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DisableUser(string userName, bool isExit)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@UserName", userName),
                    new SqlParameter("@IsExist", isExit),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Disable_User", sqlParameters);
                if ((int)sqlParameters[2].Value == 0)
                {
                    flag = true;
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("DisableUser", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool DisposeMarryRoomInfo(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@ID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Dispose_Marry_Room_Info", sqlParameters);
                flag = (int)sqlParameters[1].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("DisposeMarryRoomInfo", exception);
                    return flag;
                }
                return flag;
            }
        }

        public ConsortiaUserInfo[] GetAllMemberByConsortia(int ConsortiaID)
        {
            List<ConsortiaUserInfo> list = new List<ConsortiaUserInfo>();
            SqlDataReader ResultDataReader = null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ConsortiaID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = ConsortiaID;
                db.GetReader(ref ResultDataReader, "SP_Consortia_Users_All", SqlParameters);
                while (ResultDataReader.Read())
                {
                    list.Add(InitConsortiaUserInfo(ResultDataReader));
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public UserMatchInfo[] GetAllUserMatchInfo()
        {
            List<UserMatchInfo> list = new List<UserMatchInfo>();
            SqlDataReader resultDataReader = null;
            int num = 1;
            try
            {
                db.GetReader(ref resultDataReader, "SP_UserMatch_All_DESC");
                while (resultDataReader.Read())
                {
                    UserMatchInfo item = new UserMatchInfo
                    {
                        UserID = (int)resultDataReader["UserID"],
                        totalPrestige = (int)resultDataReader["totalPrestige"],
                        rank = num
                    };
                    list.Add(item);
                    num++;
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetAllUserMatchDESC", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public UserMatchInfo[] GetTopUserMatchInfo()
        {
            List<UserMatchInfo> list = new List<UserMatchInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                db.GetReader(ref resultDataReader, "SP_GetListLeague");
                while (resultDataReader.Read())
                {
                    UserMatchInfo item = new UserMatchInfo
                    {
                        UserID = (int)resultDataReader["UserID"],
                        totalPrestige = (int)resultDataReader["totalPrestige"],
                        weeklyRanking = (int)resultDataReader["weeklyRanking"]
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("GetTopUserMatchInfo", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }


        public AuctionInfo[] GetAuctionPage(int page, string name, int type, int pay, ref int total, int userID, int buyID, int order, bool sort, int size, string string_1)
        {
            List<AuctionInfo> auctionInfoList = new List<AuctionInfo>();
            try
            {
                string str1 = " IsExist=1 ";
                if (!string.IsNullOrEmpty(name))
                {
                    str1 = str1 + " and Name like '%" + name + "%' ";
                }
                switch (type)
                {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                    case 10:
                    case 11:
                    case 12:
                    case 13:
                    case 14:
                    case 15:
                    case 16:
                    case 17:
                    case 19:
                        str1 = str1 + " and Category =" + type + " ";
                        break;
                    case 21:
                        str1 += " and Category in(1,2,5,8,9) ";
                        break;
                    case 22:
                        str1 += " and Category in(13,15,6,4,3) ";
                        break;
                    case 23:
                        str1 += " and Category in(16,11,10) ";
                        break;
                    case 24:
                        str1 += " and Category in(8,9) ";
                        break;
                    case 25:
                        str1 += " and Category in (7,17) ";
                        break;
                    case 26:
                        str1 += " and TemplateId>=311000 and TemplateId<=313999";
                        break;
                    case 27:
                        str1 += " and TemplateId>=311000 and TemplateId<=311999 ";
                        break;
                    case 28:
                        str1 += " and TemplateId>=312000 and TemplateId<=312999 ";
                        break;
                    case 29:
                        str1 += " and TemplateId>=313000 and TempLateId<=313999";
                        break;
                    case 35:
                        str1 += " and TemplateID in (11560,11561,11562)";
                        break;
                    case 1100:
                        str1 += " and TemplateID in (11019,11021,11022,11023) ";
                        break;
                    case 1101:
                        str1 += " and TemplateID='11019' ";
                        break;
                    case 1102:
                        str1 += " and TemplateID='11021' ";
                        break;
                    case 1103:
                        str1 += " and TemplateID='11022' ";
                        break;
                    case 1104:
                        str1 += " and TemplateID='11023' ";
                        break;
                    case 1105:
                        str1 += " and TemplateID in (11001,11002,11003,11004,11005,11006,11007,11008,11009,11010,11011,11012,11013,11014,11015,11016) ";
                        break;
                    case 1106:
                        str1 += " and TemplateID in (11001,11002,11003,11004) ";
                        break;
                    case 1107:
                        str1 += " and TemplateID in (11005,11006,11007,11008) ";
                        break;
                    case 1108:
                        str1 += " and TemplateID in (11009,11010,11011,11012) ";
                        break;
                    case 1109:
                        str1 += " and TemplateID in (11013,11014,11015,11016) ";
                        break;
                    case 1110:
                        str1 += " and TemplateID='11024' ";
                        break;
                    case 1111:
                        str1 += "and TemplateID in (11039,11041,11043,11047,11040,11042,11044,11048)";
                        break;
                    case 1112:
                        str1 += "and TemplateID in (11037,11038,11045,11046)";
                        break;
                    case 1113:
                        str1 += " and TemplateID in (314101,314102,314103,314104,314105,314106,314107,314108,314109,314110,314111,314112,314113,314114,314115,314116,314121,314122,314123,314124,314125,314126,314127,314128,314129,314130,314131,314132,314133,314134) ";
                        break;
                    case 1114:
                        str1 += " and TemplateID in (314117,314118,314119,314120,314135,314136,314137,314138,314139) ";
                        break;
                    case 1116:
                        str1 += " and TemplateID='11035' ";
                        break;
                    case 1117:
                        str1 += " and TemplateID='11036' ";
                        break;
                    case 1118:
                        str1 += " and TemplateID='11026' ";
                        break;
                    case 1119:
                        str1 += " and TemplateID='11027' ";
                        break;
                }
                if (pay != -1)
                {
                    str1 = str1 + " and PayType =" + pay + " ";
                }
                if (userID != -1)
                {
                    str1 = str1 + " and AuctioneerID =" + userID + " ";
                }
                if (buyID != -1)
                {
                    str1 = str1 + " and (BuyerID =" + buyID + " or AuctionID in (" + string_1 + ")) ";
                }
                string str2 = "Category,Name,Price,dd,AuctioneerID";
                switch (order)
                {
                    case 0:
                        str2 = "Name";
                        break;
                    case 2:
                        str2 = "dd";
                        break;
                    case 3:
                        str2 = "AuctioneerName";
                        break;
                    case 4:
                        str2 = "Price";
                        break;
                    case 5:
                        str2 = "BuyerName";
                        break;
                }
                string str3 = str2 + (sort ? " desc" : "") + ",AuctionID ";
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
                    new SqlParameter("@QueryStr", "V_Auction_Scan"),
                    new SqlParameter("@QueryWhere", str1),
                    new SqlParameter("@PageSize", size),
                    new SqlParameter("@PageCurrent", page),
                    new SqlParameter("@FdShow", "*"),
                    new SqlParameter("@FdOrder", str3),
                    new SqlParameter("@FdKey", "AuctionID"),
                    new SqlParameter("@TotalRow", total)
                };
                SqlParameters[7].Direction = ParameterDirection.Output;
                DataTable dataTable = db.GetDataTable("Auction", "SP_CustomPage", SqlParameters);
                total = (int)SqlParameters[7].Value;
                foreach (DataRow row in dataTable.Rows)
                {
                    auctionInfoList.Add(new AuctionInfo
                    {
                        AuctioneerID = (int)row["AuctioneerID"],
                        AuctioneerName = row["AuctioneerName"].ToString(),
                        AuctionID = (int)row["AuctionID"],
                        BeginDate = (DateTime)row["BeginDate"],
                        BuyerID = (int)row["BuyerID"],
                        BuyerName = row["BuyerName"].ToString(),
                        Category = (int)row["Category"],
                        IsExist = (bool)row["IsExist"],
                        ItemID = (int)row["ItemID"],
                        Name = row["Name"].ToString(),
                        Mouthful = (int)row["Mouthful"],
                        PayType = (int)row["PayType"],
                        Price = (int)row["Price"],
                        Rise = (int)row["Rise"],
                        ValidDate = (int)row["ValidDate"]
                    });
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                }
            }
            return auctionInfoList.ToArray();
        }

        public AuctionInfo GetAuctionSingle(int auctionID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@AuctionID", auctionID)
                };
                db.GetReader(ref resultDataReader, "SP_Auction_Single", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitAuctionInfo(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public BestEquipInfo[] GetCelebByDayBestEquip()
        {
            List<BestEquipInfo> list = new List<BestEquipInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                db.GetReader(ref resultDataReader, "SP_Users_BestEquip");
                while (resultDataReader.Read())
                {
                    BestEquipInfo item = new BestEquipInfo
                    {
                        Date = (DateTime)resultDataReader["RemoveDate"],
                        GP = (int)resultDataReader["GP"],
                        Grade = (int)resultDataReader["Grade"],
                        ItemName = ((resultDataReader["Name"] == null) ? "" : resultDataReader["Name"].ToString()),
                        NickName = ((resultDataReader["NickName"] == null) ? "" : resultDataReader["NickName"].ToString()),
                        Sex = (bool)resultDataReader["Sex"],
                        Strengthenlevel = (int)resultDataReader["Strengthenlevel"],
                        UserName = ((resultDataReader["UserName"] == null) ? "" : resultDataReader["UserName"].ToString())
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ChargeRecordInfo[] GetChargeRecordInfo(DateTime date, int SaveRecordSecond)
        {
            List<ChargeRecordInfo> list = new List<ChargeRecordInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@Date", date.ToString("yyyy-MM-dd HH:mm:ss")),
                    new SqlParameter("@Second", SaveRecordSecond)
                };
                db.GetReader(ref resultDataReader, "SP_Charge_Record", sqlParameters);
                while (resultDataReader.Read())
                {
                    ChargeRecordInfo item = new ChargeRecordInfo
                    {
                        BoyTotalPay = (int)resultDataReader["BoyTotalPay"],
                        GirlTotalPay = (int)resultDataReader["GirlTotalPay"],
                        PayWay = ((resultDataReader["PayWay"] == null) ? "" : resultDataReader["PayWay"].ToString()),
                        TotalBoy = (int)resultDataReader["TotalBoy"],
                        TotalGirl = (int)resultDataReader["TotalGirl"]
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ExerciseInfo GetExerciseSingle(int Grade)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@Grage", Grade)
                };
                db.GetReader(ref resultDataReader, "SP_Get_Exercise_By_Grade", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new ExerciseInfo
                    {
                        Grage = (int)resultDataReader["Grage"],
                        GP = (int)resultDataReader["GP"],
                        ExerciseA = (int)resultDataReader["ExerciseA"],
                        ExerciseAG = (int)resultDataReader["ExerciseAG"],
                        ExerciseD = (int)resultDataReader["ExerciseD"],
                        ExerciseH = (int)resultDataReader["ExerciseH"],
                        ExerciseL = (int)resultDataReader["ExerciseL"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetExerciseInfoSingle", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public FriendInfo[] GetFriendsAll(int UserID)
        {
            List<FriendInfo> friendInfoList = new List<FriendInfo>();
            SqlDataReader ResultDataReader = null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = UserID;
                db.GetReader(ref ResultDataReader, "SP_Users_Friends", SqlParameters);
                while (ResultDataReader.Read())
                {
                    friendInfoList.Add(new FriendInfo
                    {
                        AddDate = (DateTime)ResultDataReader["AddDate"],
                        Colors = ((ResultDataReader["Colors"] == null) ? "" : ResultDataReader["Colors"].ToString()),
                        FriendID = (int)ResultDataReader["FriendID"],
                        Grade = (int)ResultDataReader["Grade"],
                        Hide = (int)ResultDataReader["Hide"],
                        ID = (int)ResultDataReader["ID"],
                        IsExist = (bool)ResultDataReader["IsExist"],
                        NickName = ((ResultDataReader["NickName"] == null) ? "" : ResultDataReader["NickName"].ToString()),
                        Remark = ((ResultDataReader["Remark"] == null) ? "" : ResultDataReader["Remark"].ToString()),
                        Sex = (((bool)ResultDataReader["Sex"]) ? 1 : 0),
                        State = (int)ResultDataReader["State"],
                        Style = ((ResultDataReader["Style"] == null) ? "" : ResultDataReader["Style"].ToString()),
                        UserID = (int)ResultDataReader["UserID"],
                        ConsortiaName = ((ResultDataReader["ConsortiaName"] == null) ? "" : ResultDataReader["ConsortiaName"].ToString()),
                        Offer = (int)ResultDataReader["Offer"],
                        Win = (int)ResultDataReader["Win"],
                        Total = (int)ResultDataReader["Total"],
                        Escape = (int)ResultDataReader["Escape"],
                        Relation = (int)ResultDataReader["Relation"],
                        Repute = (int)ResultDataReader["Repute"],
                        UserName = ((ResultDataReader["UserName"] == null) ? "" : ResultDataReader["UserName"].ToString()),
                        DutyName = ((ResultDataReader["DutyName"] == null) ? "" : ResultDataReader["DutyName"].ToString()),
                        Nimbus = (int)ResultDataReader["Nimbus"],
                        apprenticeshipState = (int)ResultDataReader["apprenticeshipState"]
                    });
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return friendInfoList.ToArray();
        }

        public FriendInfo[] GetFriendsBbs(string condictArray)
        {
            List<FriendInfo> list = new List<FriendInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@SearchUserName", SqlDbType.NVarChar, 4000)
                };
                sqlParameters[0].Value = condictArray;
                db.GetReader(ref resultDataReader, "SP_Users_FriendsBbs", sqlParameters);
                while (resultDataReader.Read())
                {
                    FriendInfo item = new FriendInfo
                    {
                        NickName = ((resultDataReader["NickName"] == null) ? "" : resultDataReader["NickName"].ToString()),
                        UserID = (int)resultDataReader["UserID"],
                        UserName = ((resultDataReader["UserName"] == null) ? "" : resultDataReader["UserName"].ToString()),
                        IsExist = ((int)resultDataReader["UserID"] > 0)
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ArrayList GetFriendsGood(string UserName)
        {
            ArrayList list = new ArrayList();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserName", SqlDbType.NVarChar)
                };
                sqlParameters[0].Value = UserName;
                db.GetReader(ref resultDataReader, "SP_Users_Friends_Good", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add((resultDataReader["UserName"] == null) ? "" : resultDataReader["UserName"].ToString());
                }
                return list;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return list;
                }
                return list;
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public Dictionary<int, int> GetFriendsIDAll(int UserID)
        {
            Dictionary<int, int> dictionary = new Dictionary<int, int>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_Users_Friends_All", sqlParameters);
                while (resultDataReader.Read())
                {
                    if (!dictionary.ContainsKey((int)resultDataReader["FriendID"]))
                    {
                        dictionary.Add((int)resultDataReader["FriendID"], (int)resultDataReader["Relation"]);
                    }
                    else
                    {
                        dictionary[(int)resultDataReader["FriendID"]] = (int)resultDataReader["Relation"];
                    }
                }
                return dictionary;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return dictionary;
                }
                return dictionary;
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public MailInfo[] GetMailBySenderID(int userID)
        {
            List<MailInfo> list = new List<MailInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = userID;
                db.GetReader(ref resultDataReader, "SP_Mail_BySenderID", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitMail(resultDataReader));
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public MailInfo[] GetMailByUserID(int userID)
        {
            List<MailInfo> list = new List<MailInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = userID;
                db.GetReader(ref resultDataReader, "SP_Mail_ByUserID", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitMail(resultDataReader));
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public MailInfo GetMailSingle(int UserID, int mailID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@ID", mailID),
                    new SqlParameter("@UserID", UserID)
                };
                db.GetReader(ref resultDataReader, "SP_Mail_Single", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitMail(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public MarryInfo[] GetMarryInfoPage(int page, string name, bool sex, int size, ref int total)
        {
            List<MarryInfo> list = new List<MarryInfo>();
            try
            {
                string str = ((!sex) ? " IsExist=1 and Sex=0 and UserExist=1" : " IsExist=1 and Sex=1 and UserExist=1");
                if (!string.IsNullOrEmpty(name))
                {
                    str = str + " and NickName like '%" + name + "%' ";
                }
                string str2 = "State desc,IsMarried";
                SqlParameter[] sqlParameters = new SqlParameter[8]
                {
                    new SqlParameter("@QueryStr", "V_Sys_Marry_Info"),
                    new SqlParameter("@QueryWhere", str),
                    new SqlParameter("@PageSize", size),
                    new SqlParameter("@PageCurrent", page),
                    new SqlParameter("@FdShow", "*"),
                    new SqlParameter("@FdOrder", str2),
                    new SqlParameter("@FdKey", "ID"),
                    new SqlParameter("@TotalRow", total)
                };
                sqlParameters[7].Direction = ParameterDirection.Output;
                DataTable dataTable = db.GetDataTable("V_Sys_Marry_Info", "SP_CustomPage", sqlParameters);
                total = (int)sqlParameters[7].Value;
                foreach (DataRow row in dataTable.Rows)
                {
                    MarryInfo item = new MarryInfo
                    {
                        ID = (int)row["ID"],
                        UserID = (int)row["UserID"],
                        IsPublishEquip = (bool)row["IsPublishEquip"],
                        Introduction = row["Introduction"].ToString(),
                        NickName = row["NickName"].ToString(),
                        IsConsortia = (bool)row["IsConsortia"],
                        ConsortiaID = (int)row["ConsortiaID"],
                        Sex = (bool)row["Sex"],
                        Win = (int)row["Win"],
                        Total = (int)row["Total"],
                        Escape = (int)row["Escape"],
                        GP = (int)row["GP"],
                        Honor = row["Honor"].ToString(),
                        Style = row["Style"].ToString(),
                        Colors = row["Colors"].ToString(),
                        Hide = (int)row["Hide"],
                        Grade = (int)row["Grade"],
                        State = (int)row["State"],
                        Repute = (int)row["Repute"],
                        Skin = row["Skin"].ToString(),
                        Offer = (int)row["Offer"],
                        IsMarried = (bool)row["IsMarried"],
                        ConsortiaName = row["ConsortiaName"].ToString(),
                        DutyName = row["DutyName"].ToString(),
                        Nimbus = (int)row["Nimbus"],
                        FightPower = (int)row["FightPower"],
                        typeVIP = Convert.ToByte(row["typeVIP"]),
                        VIPLevel = (int)row["VIPLevel"]
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            return list.ToArray();
        }

        public MarryInfo GetMarryInfoSingle(int ID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ID", ID)
                };
                db.GetReader(ref resultDataReader, "SP_MarryInfo_Single", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new MarryInfo
                    {
                        ID = (int)resultDataReader["ID"],
                        UserID = (int)resultDataReader["UserID"],
                        IsPublishEquip = (bool)resultDataReader["IsPublishEquip"],
                        Introduction = resultDataReader["Introduction"].ToString(),
                        RegistTime = (DateTime)resultDataReader["RegistTime"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetMarryInfoSingle", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public MarryProp GetMarryProp(int id)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", id)
                };
                db.GetReader(ref resultDataReader, "SP_Select_Marry_Prop", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new MarryProp
                    {
                        IsMarried = (bool)resultDataReader["IsMarried"],
                        SpouseID = (int)resultDataReader["SpouseID"],
                        SpouseName = resultDataReader["SpouseName"].ToString(),
                        IsCreatedMarryRoom = (bool)resultDataReader["IsCreatedMarryRoom"],
                        SelfMarryRoomID = (int)resultDataReader["SelfMarryRoomID"],
                        IsGotRing = (bool)resultDataReader["IsGotRing"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetMarryProp", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public MarryRoomInfo[] GetMarryRoomInfo()
        {
            SqlDataReader resultDataReader = null;
            List<MarryRoomInfo> list = new List<MarryRoomInfo>();
            try
            {
                db.GetReader(ref resultDataReader, "SP_Get_Marry_Room_Info");
                while (resultDataReader.Read())
                {
                    MarryRoomInfo item = new MarryRoomInfo
                    {
                        ID = (int)resultDataReader["ID"],
                        Name = resultDataReader["Name"].ToString(),
                        PlayerID = (int)resultDataReader["PlayerID"],
                        PlayerName = resultDataReader["PlayerName"].ToString(),
                        GroomID = (int)resultDataReader["GroomID"],
                        GroomName = resultDataReader["GroomName"].ToString(),
                        BrideID = (int)resultDataReader["BrideID"],
                        BrideName = resultDataReader["BrideName"].ToString(),
                        Pwd = resultDataReader["Pwd"].ToString(),
                        AvailTime = (int)resultDataReader["AvailTime"],
                        MaxCount = (int)resultDataReader["MaxCount"],
                        GuestInvite = (bool)resultDataReader["GuestInvite"],
                        MapIndex = (int)resultDataReader["MapIndex"],
                        BeginTime = (DateTime)resultDataReader["BeginTime"],
                        BreakTime = (DateTime)resultDataReader["BreakTime"],
                        RoomIntroduction = resultDataReader["RoomIntroduction"].ToString(),
                        ServerID = (int)resultDataReader["ServerID"],
                        IsHymeneal = (bool)resultDataReader["IsHymeneal"],
                        IsGunsaluteUsed = (bool)resultDataReader["IsGunsaluteUsed"]
                    };
                    list.Add(item);
                }
                return list.ToArray();
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetMarryRoomInfo", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public MarryRoomInfo GetMarryRoomInfoSingle(int id)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ID", id)
                };
                db.GetReader(ref resultDataReader, "SP_Get_Marry_Room_Info_Single", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new MarryRoomInfo
                    {
                        ID = (int)resultDataReader["ID"],
                        Name = resultDataReader["Name"].ToString(),
                        PlayerID = (int)resultDataReader["PlayerID"],
                        PlayerName = resultDataReader["PlayerName"].ToString(),
                        GroomID = (int)resultDataReader["GroomID"],
                        GroomName = resultDataReader["GroomName"].ToString(),
                        BrideID = (int)resultDataReader["BrideID"],
                        BrideName = resultDataReader["BrideName"].ToString(),
                        Pwd = resultDataReader["Pwd"].ToString(),
                        AvailTime = (int)resultDataReader["AvailTime"],
                        MaxCount = (int)resultDataReader["MaxCount"],
                        GuestInvite = (bool)resultDataReader["GuestInvite"],
                        MapIndex = (int)resultDataReader["MapIndex"],
                        BeginTime = (DateTime)resultDataReader["BeginTime"],
                        BreakTime = (DateTime)resultDataReader["BreakTime"],
                        RoomIntroduction = resultDataReader["RoomIntroduction"].ToString(),
                        ServerID = (int)resultDataReader["ServerID"],
                        IsHymeneal = (bool)resultDataReader["IsHymeneal"],
                        IsGunsaluteUsed = (bool)resultDataReader["IsGunsaluteUsed"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetMarryRoomInfo", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public void GetPasswordInfo(int userID, ref string PasswordQuestion1, ref string PasswordAnswer1, ref string PasswordQuestion2, ref string PasswordAnswer2, ref int Count)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", userID)
                };
                db.GetReader(ref resultDataReader, "SP_Users_PasswordInfo", sqlParameters);
                while (resultDataReader.Read())
                {
                    PasswordQuestion1 = ((resultDataReader["PasswordQuestion1"] == null) ? "" : resultDataReader["PasswordQuestion1"].ToString());
                    PasswordAnswer1 = ((resultDataReader["PasswordAnswer1"] == null) ? "" : resultDataReader["PasswordAnswer1"].ToString());
                    PasswordQuestion2 = ((resultDataReader["PasswordQuestion2"] == null) ? "" : resultDataReader["PasswordQuestion2"].ToString());
                    PasswordAnswer2 = ((resultDataReader["PasswordAnswer2"] == null) ? "" : resultDataReader["PasswordAnswer2"].ToString());
                    if ((DateTime)resultDataReader["LastFindDate"] == DateTime.Today)
                    {
                        Count = (int)resultDataReader["FailedPasswordAttemptCount"];
                    }
                    else
                    {
                        Count = 5;
                    }
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public MarryApplyInfo[] GetPlayerMarryApply(int UserID)
        {
            SqlDataReader resultDataReader = null;
            List<MarryApplyInfo> list = new List<MarryApplyInfo>();
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", UserID)
                };
                db.GetReader(ref resultDataReader, "SP_Get_Marry_Apply", sqlParameters);
                while (resultDataReader.Read())
                {
                    MarryApplyInfo item = new MarryApplyInfo
                    {
                        UserID = (int)resultDataReader["UserID"],
                        ApplyUserID = (int)resultDataReader["ApplyUserID"],
                        ApplyUserName = resultDataReader["ApplyUserName"].ToString(),
                        ApplyType = (int)resultDataReader["ApplyType"],
                        ApplyResult = (bool)resultDataReader["ApplyResult"],
                        LoveProclamation = resultDataReader["LoveProclamation"].ToString(),
                        ID = (int)resultDataReader["Id"]
                    };
                    list.Add(item);
                }
                return list.ToArray();
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetPlayerMarryApply", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerInfo[] GetPlayerMathPage(int page, int size, ref int total, ref bool resultValue)
        {
            List<PlayerInfo> playerInfoList = new List<PlayerInfo>();
            try
            {
                string queryWhere = "  ";
                string fdOreder = "weeklyScore desc";
                foreach (DataRow row in GetPage("V_Sys_Users_Math", queryWhere, page, size, "*", fdOreder, "UserID", ref total).Rows)
                {
                    PlayerInfo playerInfo = new PlayerInfo();
                    playerInfo.ID = (int)row["UserID"];
                    playerInfo.Colors = ((row["Colors"] == null) ? "" : row["Colors"].ToString());
                    playerInfo.GP = (int)row["GP"];
                    playerInfo.Grade = (int)row["Grade"];
                    playerInfo.ID = (int)row["UserID"];
                    playerInfo.NickName = ((row["NickName"] == null) ? "" : row["NickName"].ToString());
                    playerInfo.Sex = (bool)row["Sex"];
                    playerInfo.State = (int)row["State"];
                    playerInfo.Style = ((row["Style"] == null) ? "" : row["Style"].ToString());
                    playerInfo.Hide = (int)row["Hide"];
                    playerInfo.Repute = (int)row["Repute"];
                    playerInfo.UserName = ((row["UserName"] == null) ? "" : row["UserName"].ToString());
                    playerInfo.Skin = ((row["Skin"] == null) ? "" : row["Skin"].ToString());
                    playerInfo.Win = (int)row["Win"];
                    playerInfo.Total = (int)row["Total"];
                    playerInfo.Nimbus = (int)row["Nimbus"];
                    playerInfo.FightPower = (int)row["FightPower"];
                    playerInfo.AchievementPoint = (int)row["AchievementPoint"];
                    playerInfo.typeVIP = Convert.ToByte(row["typeVIP"]);
                    playerInfo.VIPLevel = (int)row["VIPLevel"];
                    playerInfo.AddWeekLeagueScore = (int)row["weeklyScore"];
                    playerInfoList.Add(playerInfo);
                }
                resultValue = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                }
            }
            return playerInfoList.ToArray();
        }

        public PlayerInfo[] GetPlayerPage(int page, int size, ref int total, int order, int userID, ref bool resultValue)
        {
            return GetPlayerPage(page, size, ref total, order, 0, userID, ref resultValue);
        }

        public PlayerInfo[] GetPlayerPage(int page, int size, ref int total, int order, int where, int userID, ref bool resultValue)
        {
            List<PlayerInfo> list = new List<PlayerInfo>();
            try
            {
                string queryWhere = " IsExist=1 and IsFirst<> 0 ";
                if (userID != -1)
                {
                    queryWhere = queryWhere + " and UserID =" + userID + " ";
                }
                string str = "GP desc";
                switch (order)
                {
                    case 1:
                        str = "Offer desc";
                        break;
                    case 2:
                        str = "AddDayGP desc";
                        break;
                    case 3:
                        str = "AddWeekGP desc";
                        break;
                    case 4:
                        str = "AddDayOffer desc";
                        break;
                    case 5:
                        str = "AddWeekOffer desc";
                        break;
                    case 6:
                        str = "FightPower desc";
                        break;
                    case 7:
                        str = "EliteScore desc";
                        break;
                    case 8:
                        str = "State desc, graduatesCount desc, FightPower desc";
                        break;
                    case 9:
                        str = "NEWID()";
                        break;
                    case 10:
                        str = "State desc, GP asc, FightPower desc";
                        break;
                }
                switch (where)
                {
                    case 0:
                        queryWhere += " ";
                        break;
                    case 1:
                        queryWhere += " and Grade >= 20 ";
                        break;
                    case 2:
                        queryWhere += " and Grade > 5 and Grade < 17 ";
                        break;
                    case 3:
                        queryWhere += " and Grade >= 20 and apprenticeshipState != 3 and State = 1 ";
                        break;
                    case 4:
                        queryWhere += " and Grade > 5 and Grade < 17 and masterID = 0 and State = 1 ";
                        break;
                }
                string fdOreder = str + ",UserID";
                foreach (DataRow dataRow in GetPage("V_Sys_Users_Detail", queryWhere, page, size, "*", fdOreder, "UserID", ref total).Rows)
                {
                    PlayerInfo playerInfo = new PlayerInfo();
                    playerInfo.Agility = (int)dataRow["Agility"];
                    playerInfo.Attack = (int)dataRow["Attack"];
                    playerInfo.Colors = ((dataRow["Colors"] == null) ? "" : dataRow["Colors"].ToString());
                    playerInfo.ConsortiaID = (int)dataRow["ConsortiaID"];
                    playerInfo.Defence = (int)dataRow["Defence"];
                    playerInfo.Gold = (int)dataRow["Gold"];
                    playerInfo.GP = (int)dataRow["GP"];
                    playerInfo.Grade = (int)dataRow["Grade"];
                    playerInfo.ID = (int)dataRow["UserID"];
                    playerInfo.Luck = (int)dataRow["Luck"];
                    playerInfo.Money = (int)dataRow["Money"];
                    playerInfo.NickName = ((dataRow["NickName"] == null) ? "" : dataRow["NickName"].ToString());
                    playerInfo.Sex = (bool)dataRow["Sex"];
                    playerInfo.State = (int)dataRow["State"];
                    playerInfo.Style = ((dataRow["Style"] == null) ? "" : dataRow["Style"].ToString());
                    playerInfo.Hide = (int)dataRow["Hide"];
                    playerInfo.Repute = (int)dataRow["Repute"];
                    playerInfo.UserName = ((dataRow["UserName"] == null) ? "" : dataRow["UserName"].ToString());
                    playerInfo.ConsortiaName = ((dataRow["ConsortiaName"] == null) ? "" : dataRow["ConsortiaName"].ToString());
                    playerInfo.Offer = (int)dataRow["Offer"];
                    playerInfo.Skin = ((dataRow["Skin"] == null) ? "" : dataRow["Skin"].ToString());
                    playerInfo.IsBanChat = (bool)dataRow["IsBanChat"];
                    playerInfo.ReputeOffer = (int)dataRow["ReputeOffer"];
                    playerInfo.ConsortiaRepute = (int)dataRow["ConsortiaRepute"];
                    playerInfo.ConsortiaLevel = (int)dataRow["ConsortiaLevel"];
                    playerInfo.StoreLevel = (int)dataRow["StoreLevel"];
                    playerInfo.ShopLevel = (int)dataRow["ShopLevel"];
                    playerInfo.SmithLevel = (int)dataRow["SmithLevel"];
                    playerInfo.ConsortiaHonor = (int)dataRow["ConsortiaHonor"];
                    playerInfo.RichesOffer = (int)dataRow["RichesOffer"];
                    playerInfo.RichesRob = (int)dataRow["RichesRob"];
                    playerInfo.DutyLevel = (int)dataRow["DutyLevel"];
                    playerInfo.DutyName = ((dataRow["DutyName"] == null) ? "" : dataRow["DutyName"].ToString());
                    playerInfo.Right = (int)dataRow["Right"];
                    playerInfo.ChairmanName = ((dataRow["ChairmanName"] == null) ? "" : dataRow["ChairmanName"].ToString());
                    playerInfo.Win = (int)dataRow["Win"];
                    playerInfo.Total = (int)dataRow["Total"];
                    playerInfo.Escape = (int)dataRow["Escape"];
                    playerInfo.AddDayGP = (int)dataRow["AddDayGP"];
                    playerInfo.AddDayOffer = (int)dataRow["AddDayOffer"];
                    playerInfo.AddWeekGP = (int)dataRow["AddWeekGP"];
                    playerInfo.AddWeekOffer = (int)dataRow["AddWeekOffer"];
                    playerInfo.ConsortiaRiches = (int)dataRow["ConsortiaRiches"];
                    playerInfo.CheckCount = (int)dataRow["CheckCount"];
                    playerInfo.Nimbus = (int)dataRow["Nimbus"];
                    playerInfo.GiftToken = (int)dataRow["GiftToken"];
                    playerInfo.QuestSite = ((dataRow["QuestSite"] == null) ? new byte[200] : ((byte[])dataRow["QuestSite"]));
                    playerInfo.PvePermission = ((dataRow["PvePermission"] == null) ? "" : dataRow["PvePermission"].ToString());
                    playerInfo.FightLabPermission = ((dataRow["FightLabPermission"] == DBNull.Value) ? "" : dataRow["FightLabPermission"].ToString());
                    playerInfo.FightPower = (int)dataRow["FightPower"];
                    playerInfo.AchievementPoint = (int)dataRow["AchievementPoint"];
                    playerInfo.Honor = (string)dataRow["Honor"];
                    playerInfo.IsShowConsortia = (bool)dataRow["IsShowConsortia"];
                    playerInfo.OptionOnOff = (int)dataRow["OptionOnOff"];
                    playerInfo.badgeID = (int)dataRow["badgeID"];
                    playerInfo.EliteScore = (int)dataRow["EliteScore"];
                    playerInfo.apprenticeshipState = (int)dataRow["apprenticeshipState"];
                    playerInfo.masterID = (int)dataRow["masterID"];
                    playerInfo.graduatesCount = (int)dataRow["graduatesCount"];
                    playerInfo.masterOrApprentices = ((dataRow["masterOrApprentices"] == DBNull.Value) ? "" : dataRow["masterOrApprentices"].ToString());
                    playerInfo.honourOfMaster = ((dataRow["honourOfMaster"] == DBNull.Value) ? "" : dataRow["honourOfMaster"].ToString());
                    playerInfo.IsMarried = (bool)dataRow["IsMarried"];
                    playerInfo.typeVIP = Convert.ToByte(dataRow["typeVIP"]);
                    playerInfo.VIPLevel = (int)dataRow["VIPLevel"];
                    playerInfo.SpouseID = (int)dataRow["SpouseID"];
                    playerInfo.SpouseName = ((dataRow["SpouseName"] == DBNull.Value) ? "" : dataRow["SpouseName"].ToString());
                    list.Add(playerInfo);
                }
                resultValue = true;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                }
            }
            return list.ToArray();
        }

        public string GetSingleRandomName(int sex)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                if (sex > 1)
                {
                    sex = 1;
                }
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@Sex", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = sex;
                db.GetReader(ref resultDataReader, "SP_GetSingle_RandomName", sqlParameters);
                if (resultDataReader.Read())
                {
                    return (resultDataReader["Name"] == null) ? "unknown" : resultDataReader["Name"].ToString();
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetSingleRandomName", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public UserMatchInfo GetSingleUserMatchInfo(int UserID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_GetSingleUserMatchInfo", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new UserMatchInfo
                    {
                        ID = (int)resultDataReader["ID"],
                        UserID = (int)resultDataReader["UserID"],
                        dailyScore = (int)resultDataReader["dailyScore"],
                        dailyWinCount = (int)resultDataReader["dailyWinCount"],
                        dailyGameCount = (int)resultDataReader["dailyGameCount"],
                        DailyLeagueFirst = (bool)resultDataReader["DailyLeagueFirst"],
                        DailyLeagueLastScore = (int)resultDataReader["DailyLeagueLastScore"],
                        weeklyScore = (int)resultDataReader["weeklyScore"],
                        weeklyGameCount = (int)resultDataReader["weeklyGameCount"],
                        weeklyRanking = (int)resultDataReader["weeklyRanking"],
                        addDayPrestge = (int)resultDataReader["addDayPrestge"],
                        totalPrestige = (int)resultDataReader["totalPrestige"],
                        restCount = (int)resultDataReader["restCount"],
                        leagueGrade = (int)resultDataReader["leagueGrade"],
                        leagueItemsGet = (int)resultDataReader["leagueItemsGet"],
                        WeeklyWinCount = (int)resultDataReader["WeeklyWinCount"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_GetSingleUserMatchInfo", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public List<UserRankInfo> GetSingleUserRank(int UserID)
        {
            SqlDataReader reader = null;
            List<UserRankInfo> infos = new List<UserRankInfo>();
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = UserID;
                db.GetReader(ref reader, "SP_GetSingleUserRank", para);
                while (reader.Read())
                {
                    UserRankInfo info = new UserRankInfo();
                    info.ID = (int)reader["ID"];
                    info.UserID = (int)reader["UserID"];
                    info.Name = (string)reader["UserRank"];
                    info.Attack = (int)reader["Attack"];
                    info.Defence = (int)reader["Defence"];
                    info.Luck = (int)reader["Luck"];
                    info.Agility = (int)reader["Agility"];
                    info.HP = (int)reader["HP"];
                    info.Damage = (int)reader["Damage"];
                    info.Guard = (int)reader["Guard"];
                    info.BeginDate = (DateTime)reader["BeginDate"];
                    info.Validate = (int)reader["Validate"];
                    info.IsExit = (bool)reader["IsExit"];
                    info.NewTitleID = (int)reader["NewTitleID"];
                    info.EndDate = (DateTime)reader["EndDate"];
                    infos.Add(info);
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_GetSingleUserRankInfo", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return infos;
        }

        public UsersExtraInfo GetSingleUsersExtra(int UserID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_GetSingleUsersExtra", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new UsersExtraInfo
                    {
                        UserID = (int)resultDataReader["UserID"],
                        LastTimeHotSpring = (DateTime)resultDataReader["LastTimeHotSpring"],
                        LastFreeTimeHotSpring = (DateTime)resultDataReader["LastFreeTimeHotSpring"],
                        MinHotSpring = (int)resultDataReader["MinHotSpring"],
                        coupleBossEnterNum = (int)resultDataReader["coupleBossEnterNum"],
                        coupleBossHurt = (int)resultDataReader["coupleBossHurt"],
                        coupleBossBoxNum = (int)resultDataReader["coupleBossBoxNum"],
                        LeftRoutteCount = ((resultDataReader["LeftRoutteCount"] == DBNull.Value) ? GameProperties.LeftRouterMaxDay : ((int)resultDataReader["LeftRoutteCount"])),
                        LeftRoutteRate = ((resultDataReader["LeftRoutteRate"] == DBNull.Value) ? 0f : float.Parse(resultDataReader["LeftRoutteRate"].ToString())),
                        FreeSendMailCount = (int)resultDataReader["FreeSendMailCount"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_GetSingleUsersExtra", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }
        public int GetXepHang(int UserID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_User_Repute", sqlParameters);
                if (resultDataReader.Read())
                {
                    int fightpower = 0;
                    int rank = 0;
                    fightpower = (int)resultDataReader["FightPower"];
                    rank = Convert.ToInt32(resultDataReader["RowNumber"]);
                    return rank;
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_User_Repute", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return 0;
        }

        public AchievementData[] GetUserAchievement(int userID)
        {
            List<AchievementData> list = new List<AchievementData>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = userID;
                db.GetReader(ref resultDataReader, "SP_Get_User_AchievementData", sqlParameters);
                while (resultDataReader.Read())
                {
                    AchievementData item = new AchievementData
                    {
                        UserID = (int)resultDataReader["UserID"],
                        AchievementID = (int)resultDataReader["AchievementID"],
                        IsComplete = (bool)resultDataReader["IsComplete"],
                        CompletedDate = (DateTime)resultDataReader["CompletedDate"]
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ItemInfo[] GetUserBagByType(int UserID, int bagType)
        {
            List<ItemInfo> items = new List<ItemInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[2];
                para[0] = new SqlParameter("@UserID", SqlDbType.Int, 4);
                para[0].Value = UserID;
                para[1] = new SqlParameter("@BagType", bagType);
                db.GetReader(ref reader, "SP_Users_BagByType", para);

                while (reader.Read())
                {
                    items.Add(InitItem(reader));
                }

            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                    reader.Close();
            }
            return items.ToArray();

        }

        public List<ItemInfo> GetUserBeadEuqip(int UserID)
        {
            List<ItemInfo> list = new List<ItemInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_Users_Bead_Equip", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitItem(resultDataReader));
                }
                return list;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return list;
                }
                return list;
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public BufferInfo[] GetUserBuffer(int userID)
        {
            List<BufferInfo> list = new List<BufferInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = userID;
                db.GetReader(ref resultDataReader, "SP_User_Buff_All", sqlParameters);
                while (resultDataReader.Read())
                {
                    BufferInfo item = new BufferInfo
                    {
                        BeginDate = (DateTime)resultDataReader["BeginDate"],
                        Data = ((resultDataReader["Data"] == null) ? "" : resultDataReader["Data"].ToString()),
                        Type = (int)resultDataReader["Type"],
                        UserID = (int)resultDataReader["UserID"],
                        ValidDate = (int)resultDataReader["ValidDate"],
                        Value = (int)resultDataReader["Value"],
                        IsExist = (bool)resultDataReader["IsExist"],
                        ValidCount = (int)resultDataReader["ValidCount"],
                        TemplateID = (int)resultDataReader["TemplateID"],
                        IsDirty = false
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public UsersCardInfo GetUserCardByPlace(int Place)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@Place", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = Place;
                db.GetReader(ref resultDataReader, "SP_Get_UserCard_By_Place", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitCard(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public List<UsersCardInfo> GetUserCardEuqip(int UserID)
        {
            List<UsersCardInfo> list = new List<UsersCardInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_Users_Items_Card_Equip", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitCard(resultDataReader));
                }
                return list;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return list;
                }
                return list;
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public UsersCardInfo[] GetUserCardSingles(int UserID)
        {
            List<UsersCardInfo> list = new List<UsersCardInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_Get_UserCard_By_ID", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitCard(resultDataReader));
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ConsortiaBufferInfo[] GetUserConsortiaBuffer(int ConsortiaID)
        {
            List<ConsortiaBufferInfo> list = new List<ConsortiaBufferInfo>();
            SqlDataReader ResultDataReader = null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ConsortiaID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = ConsortiaID;
                db.GetReader(ref ResultDataReader, "SP_User_Consortia_Buff_All", SqlParameters);
                while (ResultDataReader.Read())
                {
                    list.Add(new ConsortiaBufferInfo
                    {
                        ConsortiaID = (int)ResultDataReader["ConsortiaID"],
                        BufferID = (int)ResultDataReader["BufferID"],
                        IsOpen = (bool)ResultDataReader["IsOpen"],
                        BeginDate = (DateTime)ResultDataReader["BeginDate"],
                        ValidDate = (int)ResultDataReader["ValidDate"],
                        Type = (int)ResultDataReader["Type"],
                        Value = (int)ResultDataReader["Value"]
                    });
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init SP_User_Consortia_Buff_All", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ConsortiaBufferInfo[] GetUserConsortiaBufferLess(int ConsortiaID, int LessID)
        {
            List<ConsortiaBufferInfo> list = new List<ConsortiaBufferInfo>();
            SqlDataReader ResultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[]
                {
                    new SqlParameter("@ConsortiaID", SqlDbType.Int, 4),
                    null
                };
                sqlParameters[0].Value = ConsortiaID;
                sqlParameters[1] = new SqlParameter("@LessID", LessID);
                db.GetReader(ref ResultDataReader, "SP_User_Consortia_Buff_All", sqlParameters);
                while (ResultDataReader.Read())
                {
                    list.Add(new ConsortiaBufferInfo
                    {
                        ConsortiaID = (int)ResultDataReader["ConsortiaID"],
                        BufferID = (int)ResultDataReader["BufferID"],
                        IsOpen = (bool)ResultDataReader["IsOpen"],
                        BeginDate = (DateTime)ResultDataReader["BeginDate"],
                        ValidDate = (int)ResultDataReader["ValidDate"],
                        Type = (int)ResultDataReader["Type"],
                        Value = (int)ResultDataReader["Value"]
                    });
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init SP_User_Consortia_Buff_AllL", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ConsortiaBufferInfo GetUserConsortiaBufferSingle(int ID, int conid)
        {
            SqlDataReader ResultDataReader = null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[]
                {
                    new SqlParameter("@ID", SqlDbType.Int, 4),
                    new SqlParameter("@ConsortiaID", SqlDbType.Int, 4),

                };
                SqlParameters[0].Value = ID;
                SqlParameters[1].Value = conid;
                db.GetReader(ref ResultDataReader, "SP_User_Consortia_Buff_Single", SqlParameters);
                if (ResultDataReader.Read())
                {
                    return new ConsortiaBufferInfo
                    {
                        ConsortiaID = (int)ResultDataReader["ConsortiaID"],
                        BufferID = (int)ResultDataReader["BufferID"],
                        IsOpen = (bool)ResultDataReader["IsOpen"],
                        BeginDate = (DateTime)ResultDataReader["BeginDate"],
                        ValidDate = (int)ResultDataReader["ValidDate"],
                        Type = (int)ResultDataReader["Type"],
                        Value = (int)ResultDataReader["Value"]
                    };
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init SP_User_Consortia_Buff_Single", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return null;
        }

        public List<ItemInfo> GetUserEuqip(int UserID)
        {
            List<ItemInfo> list = new List<ItemInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_Users_Items_Equip", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitItem(resultDataReader));
                }
                return list;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return list;
                }
                return list;
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public List<ItemInfo> GetUserEuqipByNick(string Nick)
        {
            List<ItemInfo> list = new List<ItemInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@NickName", SqlDbType.NVarChar, 200)
                };
                sqlParameters[0].Value = Nick;
                db.GetReader(ref resultDataReader, "SP_Users_Items_Equip_By_Nick", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitItem(resultDataReader));
                }
                return list;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return list;
                }
                return list;
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public EventRewardProcessInfo[] GetUserEventProcess(int userID)
        {
            SqlDataReader resultDataReader = null;
            List<EventRewardProcessInfo> list = new List<EventRewardProcessInfo>();
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = userID;
                db.GetReader(ref resultDataReader, "SP_Get_User_EventProcess", sqlParameters);
                while (resultDataReader.Read())
                {
                    EventRewardProcessInfo item = new EventRewardProcessInfo
                    {
                        UserID = (int)resultDataReader["UserID"],
                        ActiveType = (int)resultDataReader["ActiveType"],
                        Conditions = (int)resultDataReader["Conditions"],
                        AwardGot = (int)resultDataReader["AwardGot"]
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public UserInfo GetUserInfo(int UserId)
        {
            SqlDataReader resultDataReader = null;
            UserInfo info = new UserInfo
            {
                UserID = UserId
            };
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", UserId)
                };
                db.GetReader(ref resultDataReader, "SP_Get_User_Info", sqlParameters);
                while (resultDataReader.Read())
                {
                    info.UserID = int.Parse(resultDataReader["UserID"].ToString());
                    info.UserEmail = ((resultDataReader["UserEmail"] == null) ? "" : resultDataReader["UserEmail"].ToString());
                    info.UserPhone = ((resultDataReader["UserPhone"] == null) ? "" : resultDataReader["UserPhone"].ToString());
                    info.UserOther1 = ((resultDataReader["UserOther1"] == null) ? "" : resultDataReader["UserOther1"].ToString());
                    info.UserOther2 = ((resultDataReader["UserOther2"] == null) ? "" : resultDataReader["UserOther2"].ToString());
                    info.UserOther3 = ((resultDataReader["UserOther3"] == null) ? "" : resultDataReader["UserOther3"].ToString());
                }
                return info;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return info;
                }
                return info;
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
        }

        public ItemInfo[] GetUserItem(int UserID)
        {
            List<ItemInfo> list = new List<ItemInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_Users_Items_All", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitItem(resultDataReader));
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public ItemInfo GetUserItemSingle(int itemID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = itemID;
                db.GetReader(ref resultDataReader, "SP_Users_Items_Single", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitItem(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public LevelInfo GetUserLevelSingle(int Grade)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@Grade", Grade)
                };
                db.GetReader(ref resultDataReader, "SP_Get_Level_By_Grade", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new LevelInfo
                    {
                        Grade = (int)resultDataReader["Grade"],
                        GP = (int)resultDataReader["GP"],
                        Blood = (int)resultDataReader["Blood"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetLevelInfoSingle", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerLimitInfo GetUserLimitByUserName(string userName)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserName", SqlDbType.NVarChar, 200)
                };
                sqlParameters[0].Value = userName;
                db.GetReader(ref resultDataReader, "SP_Users_LimitByUserName", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new PlayerLimitInfo
                    {
                        ID = (int)resultDataReader["UserID"],
                        NickName = (string)resultDataReader["NickName"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerInfo[] GetUserLoginList(string userName)
        {
            List<PlayerInfo> list = new List<PlayerInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserName", SqlDbType.NVarChar, 200)
                };
                sqlParameters[0].Value = userName;
                db.GetReader(ref resultDataReader, "SP_Users_LoginList", sqlParameters);
                while (resultDataReader.Read())
                {
                    list.Add(InitPlayerInfo(resultDataReader));
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public QuestDataInfo[] GetUserQuest(int userID)
        {
            List<QuestDataInfo> infos = new List<QuestDataInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = userID;
                db.GetReader(ref reader, "SP_QuestData_All", para);
                while (reader.Read())
                {
                    infos.Add(new QuestDataInfo
                    {
                        CompletedDate = (DateTime)reader["CompletedDate"],
                        IsComplete = (bool)reader["IsComplete"],
                        Condition1 = (int)reader["Condition1"],
                        Condition2 = (int)reader["Condition2"],
                        Condition3 = (int)reader["Condition3"],
                        Condition4 = (int)reader["Condition4"],
                        QuestID = (int)reader["QuestID"],
                        UserID = (int)reader["UserId"],
                        IsExist = (bool)reader["IsExist"],
                        RandDobule = (int)reader["RandDobule"],
                        RepeatFinish = (int)reader["RepeatFinish"],
                        IsDirty = false
                    });
                }
            }
            catch (Exception e)
            {
                BaseBussiness.log.Error("Init", e);
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return infos.ToArray();
        }

        public QuestDataInfo GetUserQuestSiger(int userID, int QuestID)
        {
            new QuestDataInfo();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", SqlDbType.Int),
                    new SqlParameter("@QuestID", SqlDbType.Int)
                };
                sqlParameters[0].Value = userID;
                sqlParameters[1].Value = QuestID;
                db.GetReader(ref resultDataReader, "SP_QuestData_One", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new QuestDataInfo
                    {
                        CompletedDate = (DateTime)resultDataReader["CompletedDate"],
                        IsComplete = (bool)resultDataReader["IsComplete"],
                        Condition1 = (int)resultDataReader["Condition1"],
                        Condition2 = (int)resultDataReader["Condition2"],
                        Condition3 = (int)resultDataReader["Condition3"],
                        Condition4 = (int)resultDataReader["Condition4"],
                        QuestID = (int)resultDataReader["QuestID"],
                        UserID = (int)resultDataReader["UserId"],
                        IsExist = (bool)resultDataReader["IsExist"],
                        RandDobule = (int)resultDataReader["RandDobule"],
                        RepeatFinish = (int)resultDataReader["RepeatFinish"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerInfo GetUserSingleByNickName(string nickName)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@NickName", SqlDbType.NVarChar, 200)
                };
                sqlParameters[0].Value = nickName;
                db.GetReader(ref resultDataReader, "SP_Users_SingleByNickName", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitPlayerInfo(resultDataReader);
                }
            }
            catch
            {
                throw new Exception();
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerInfo GetUserSingleByUserID(int UserID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                sqlParameters[0].Value = UserID;
                db.GetReader(ref resultDataReader, "SP_Users_SingleByUserID", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitPlayerInfo(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerInfo GetUserSingleByUserName(string userName)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserName", SqlDbType.NVarChar, 200)
                };
                sqlParameters[0].Value = userName;
                db.GetReader(ref resultDataReader, "SP_Users_SingleByUserName", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitPlayerInfo(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public TexpInfo GetUserTexpInfoSingle(int ID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", ID)
                };
                db.GetReader(ref resultDataReader, "SP_Get_UserTexp_By_ID", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new TexpInfo
                    {
                        UserID = (int)resultDataReader["UserID"],
                        attTexpExp = (int)resultDataReader["attTexpExp"],
                        defTexpExp = (int)resultDataReader["defTexpExp"],
                        hpTexpExp = (int)resultDataReader["hpTexpExp"],
                        lukTexpExp = (int)resultDataReader["lukTexpExp"],
                        spdTexpExp = (int)resultDataReader["spdTexpExp"],
                        texpCount = (int)resultDataReader["texpCount"],
                        texpTaskCount = (int)resultDataReader["texpTaskCount"],
                        texpTaskDate = (DateTime)resultDataReader["texpTaskDate"]
                    };
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetTexpInfoSingle", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public UsersCardInfo[] GetSingleUserCard(int UserID)
        {
            SqlDataReader ResultDataReader = null;
            List<UsersCardInfo> userCardInfoList = new List<UsersCardInfo>();
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = UserID;
                db.GetReader(ref ResultDataReader, "SP_GetSingleUserCard", SqlParameters);
                while (ResultDataReader.Read())
                {
                    UsersCardInfo userCardInfo = InitCard(ResultDataReader);
                    userCardInfoList.Add(userCardInfo);
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetSingleUserCard", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return userCardInfoList.ToArray();
        }

        public int GetVip(string UserName)
        {
            int num = 0;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserName", UserName),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_GetVip", sqlParameters);
                num = (int)sqlParameters[1].Value;
                return num;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return num;
                }
                return num;
            }
        }

        public AuctionInfo InitAuctionInfo(SqlDataReader reader)
        {
            return new AuctionInfo
            {
                AuctioneerID = (int)reader["AuctioneerID"],
                AuctioneerName = ((reader["AuctioneerName"] == null) ? "" : reader["AuctioneerName"].ToString()),
                AuctionID = (int)reader["AuctionID"],
                BeginDate = (DateTime)reader["BeginDate"],
                BuyerID = (int)reader["BuyerID"],
                BuyerName = ((reader["BuyerName"] == null) ? "" : reader["BuyerName"].ToString()),
                IsExist = (bool)reader["IsExist"],
                ItemID = (int)reader["ItemID"],
                Mouthful = (int)reader["Mouthful"],
                PayType = (int)reader["PayType"],
                Price = (int)reader["Price"],
                Rise = (int)reader["Rise"],
                ValidDate = (int)reader["ValidDate"],
                Name = reader["Name"].ToString(),
                Category = (int)reader["Category"],
                goodsCount = (int)reader["goodsCount"]
            };
        }

        private UsersCardInfo InitCard(SqlDataReader sqlDataReader_0)
        {
            return new UsersCardInfo
            {
                CardID = (int)sqlDataReader_0["CardID"],
                UserID = (int)sqlDataReader_0["UserID"],
                TemplateID = (int)sqlDataReader_0["TemplateID"],
                Place = (int)sqlDataReader_0["Place"],
                Count = (int)sqlDataReader_0["Count"],
                Attack = (int)sqlDataReader_0["Attack"],
                Defence = (int)sqlDataReader_0["Defence"],
                Agility = (int)sqlDataReader_0["Agility"],
                Luck = (int)sqlDataReader_0["Luck"],
                AttackReset = (int)sqlDataReader_0["AttackReset"],
                DefenceReset = (int)sqlDataReader_0["DefenceReset"],
                AgilityReset = (int)sqlDataReader_0["AgilityReset"],
                LuckReset = (int)sqlDataReader_0["LuckReset"],
                Guard = (int)sqlDataReader_0["Guard"],
                Damage = (int)sqlDataReader_0["Damage"],
                Level = (int)sqlDataReader_0["Level"],
                CardGP = (int)sqlDataReader_0["CardGP"],
                isFirstGet = (bool)sqlDataReader_0["isFirstGet"]
            };
        }

        public CardGrooveUpdateInfo InitCardGrooveUpdate(SqlDataReader reader)
        {
            return new CardGrooveUpdateInfo
            {
                ID = (int)reader["ID"],
                Attack = (int)reader["Attack"],
                Defend = (int)reader["Defend"],
                Agility = (int)reader["Agility"],
                Lucky = (int)reader["Lucky"],
                Damage = (int)reader["Damage"],
                Guard = (int)reader["Guard"],
                Level = (int)reader["Level"],
                Type = (int)reader["Type"],
                Exp = (int)reader["Exp"]
            };
        }

        public CardTemplateInfo InitCardTemplate(SqlDataReader reader)
        {
            return new CardTemplateInfo
            {
                ID = (int)reader["ID"],
                CardID = (int)reader["CardID"],
                Count = (int)reader["Count"],
                probability = (int)reader["probability"],
                AttackRate = (int)reader["Attack"],
                AddAttack = (int)reader["AddAttack"],
                DefendRate = (int)reader["DefendRate"],
                AddDefend = (int)reader["AddDefend"],
                AgilityRate = (int)reader["AgilityRate"],
                AddAgility = (int)reader["AddAgility"],
                LuckyRate = (int)reader["LuckyRate"],
                AddLucky = (int)reader["AddLucky"],
                DamageRate = (int)reader["DamageRate"],
                AddDamage = (int)reader["AddDamage"],
                GuardRate = (int)reader["GuardRate"],
                AddGuard = (int)reader["AddGuard"]
            };
        }

        public ConsortiaUserInfo InitConsortiaUserInfo(SqlDataReader dr)
        {
            ConsortiaUserInfo consortiaUserInfo = new ConsortiaUserInfo();
            consortiaUserInfo.ID = (int)dr["ID"];
            consortiaUserInfo.ConsortiaID = (int)dr["ConsortiaID"];
            consortiaUserInfo.DutyID = (int)dr["DutyID"];
            consortiaUserInfo.DutyName = dr["DutyName"].ToString();
            consortiaUserInfo.IsExist = (bool)dr["IsExist"];
            consortiaUserInfo.RatifierID = (int)dr["RatifierID"];
            consortiaUserInfo.RatifierName = dr["RatifierName"].ToString();
            consortiaUserInfo.Remark = dr["Remark"].ToString();
            consortiaUserInfo.UserID = (int)dr["UserID"];
            consortiaUserInfo.UserName = dr["UserName"].ToString();
            consortiaUserInfo.Grade = (int)dr["Grade"];
            consortiaUserInfo.GP = (int)dr["GP"];
            consortiaUserInfo.Repute = (int)dr["Repute"];
            consortiaUserInfo.State = (int)dr["State"];
            consortiaUserInfo.Right = (int)dr["Right"];
            consortiaUserInfo.Offer = (int)dr["Offer"];
            consortiaUserInfo.Colors = dr["Colors"].ToString();
            consortiaUserInfo.Style = dr["Style"].ToString();
            consortiaUserInfo.Hide = (int)dr["Hide"];
            consortiaUserInfo.Skin = ((dr["Skin"] == null) ? "" : consortiaUserInfo.Skin);
            consortiaUserInfo.Level = (int)dr["Level"];
            consortiaUserInfo.LastDate = (DateTime)dr["LastDate"];
            consortiaUserInfo.Sex = (bool)dr["Sex"];
            consortiaUserInfo.IsBanChat = (bool)dr["IsBanChat"];
            consortiaUserInfo.Win = (int)dr["Win"];
            consortiaUserInfo.Total = (int)dr["Total"];
            consortiaUserInfo.Escape = (int)dr["Escape"];
            consortiaUserInfo.RichesOffer = (int)dr["RichesOffer"];
            consortiaUserInfo.RichesRob = (int)dr["RichesRob"];
            consortiaUserInfo.LoginName = ((dr["LoginName"] == null) ? "" : dr["LoginName"].ToString());
            consortiaUserInfo.Nimbus = (int)dr["Nimbus"];
            consortiaUserInfo.FightPower = (int)dr["FightPower"];
            consortiaUserInfo.typeVIP = Convert.ToByte(dr["typeVIP"]);
            consortiaUserInfo.VIPLevel = (int)dr["VIPLevel"];
            return consortiaUserInfo;
        }

        public ItemInfo InitItem(SqlDataReader reader)
        {
            ItemInfo item = new ItemInfo(ItemMgr.FindItemTemplate((int)reader["TemplateID"]));
            item.AgilityCompose = (int)reader["AgilityCompose"];
            item.AttackCompose = (int)reader["AttackCompose"];
            item.Color = reader["Color"].ToString();
            item.Count = (int)reader["Count"];
            item.DefendCompose = (int)reader["DefendCompose"];
            item.ItemID = (int)reader["ItemID"];
            item.LuckCompose = (int)reader["LuckCompose"];
            item.Place = (int)reader["Place"];
            item.StrengthenLevel = (int)reader["StrengthenLevel"];
            item.TemplateID = (int)reader["TemplateID"];
            item.UserID = (int)reader["UserID"];
            item.ValidDate = (int)reader["ValidDate"];
            item.IsDirty = false;
            item.IsExist = (bool)reader["IsExist"];
            item.IsBinds = (bool)reader["IsBinds"];
            item.IsUsed = (bool)reader["IsUsed"];
            item.BeginDate = (DateTime)reader["BeginDate"];
            item.IsJudge = (bool)reader["IsJudge"];
            item.BagType = (int)reader["BagType"];
            item.Skin = reader["Skin"].ToString();
            item.RemoveDate = (DateTime)reader["RemoveDate"];
            item.RemoveType = (int)reader["RemoveType"];
            item.Hole1 = (int)reader["Hole1"];
            item.Hole2 = (int)reader["Hole2"];
            item.Hole3 = (int)reader["Hole3"];
            item.Hole4 = (int)reader["Hole4"];
            item.Hole5 = (int)reader["Hole5"];
            item.Hole6 = (int)reader["Hole6"];
            item.Hole5Level = (int)reader["Hole5Level"];
            item.Hole5Exp = (int)reader["Hole5Exp"];
            item.Hole6Level = (int)reader["Hole6Level"];
            item.Hole6Exp = (int)reader["Hole6Exp"];
            item.StrengthenTimes = (int)reader["StrengthenTimes"];
            item.goldBeginTime = (DateTime)reader["goldBeginTime"];
            item.goldValidDate = (int)reader["goldValidDate"];
            item.StrengthenExp = (int)reader["StrengthenExp"];
            item.Blood = (int)reader["Blood"];
            item.latentEnergyCurStr = (string)reader["latentEnergyCurStr"];
            item.latentEnergyNewStr = (string)reader["latentEnergyNewStr"];
            item.latentEnergyEndTime = (DateTime)reader["latentEnergyEndTime"];
            item.GoldEquip = ItemMgr.FindGoldItemTemplate(item.TemplateID, item.isGold);
            item.IsDirty = false;
            return item;
        }

        public MailInfo InitMail(SqlDataReader reader)
        {
            return new MailInfo
            {
                Annex1 = reader["Annex1"].ToString(),
                Annex2 = reader["Annex2"].ToString(),
                Content = reader["Content"].ToString(),
                Gold = (int)reader["Gold"],
                ID = (int)reader["ID"],
                IsExist = (bool)reader["IsExist"],
                Money = (int)reader["Money"],
                GiftToken = (int)reader["GiftToken"],
                Receiver = reader["Receiver"].ToString(),
                ReceiverID = (int)reader["ReceiverID"],
                Sender = reader["Sender"].ToString(),
                SenderID = (int)reader["SenderID"],
                Title = reader["Title"].ToString(),
                Type = (int)reader["Type"],
                ValidDate = (int)reader["ValidDate"],
                IsRead = (bool)reader["IsRead"],
                SendTime = (DateTime)reader["SendTime"],
                Annex1Name = ((reader["Annex1Name"] == null) ? "" : reader["Annex1Name"].ToString()),
                Annex2Name = ((reader["Annex2Name"] == null) ? "" : reader["Annex2Name"].ToString()),
                Annex3 = reader["Annex3"].ToString(),
                Annex4 = reader["Annex4"].ToString(),
                Annex5 = reader["Annex5"].ToString(),
                Annex3Name = ((reader["Annex3Name"] == null) ? "" : reader["Annex3Name"].ToString()),
                Annex4Name = ((reader["Annex4Name"] == null) ? "" : reader["Annex4Name"].ToString()),
                Annex5Name = ((reader["Annex5Name"] == null) ? "" : reader["Annex5Name"].ToString()),
                AnnexRemark = ((reader["AnnexRemark"] == null) ? "" : reader["AnnexRemark"].ToString())
            };
        }

        public PlayerInfo InitPlayerInfo(SqlDataReader reader)
        {
            PlayerInfo playerInfo = new PlayerInfo();
            playerInfo.Password = (string)reader["Password"];
            playerInfo.IsConsortia = (bool)reader["IsConsortia"];
            playerInfo.Agility = (int)reader["Agility"];
            playerInfo.Attack = (int)reader["Attack"];
            playerInfo.hp = (int)reader["hp"];
            playerInfo.Colors = ((reader["Colors"] == null) ? "" : reader["Colors"].ToString());
            playerInfo.ConsortiaID = (int)reader["ConsortiaID"];
            playerInfo.Defence = (int)reader["Defence"];
            playerInfo.Gold = (int)reader["Gold"];
            playerInfo.GP = (int)reader["GP"];
            playerInfo.Grade = (int)reader["Grade"];
            playerInfo.ID = (int)reader["UserID"];
            playerInfo.Luck = (int)reader["Luck"];
            playerInfo.Money = (int)reader["Money"];
            playerInfo.NickName = (((string)reader["NickName"] == null) ? "" : ((string)reader["NickName"]));
            playerInfo.Sex = (bool)reader["Sex"];
            playerInfo.State = (int)reader["State"];
            playerInfo.Style = ((reader["Style"] == null) ? "" : reader["Style"].ToString());
            playerInfo.Hide = (int)reader["Hide"];
            playerInfo.Repute = (int)reader["Repute"];
            playerInfo.UserName = ((reader["UserName"] == null) ? "" : reader["UserName"].ToString());
            playerInfo.ConsortiaName = ((reader["ConsortiaName"] == null) ? "" : reader["ConsortiaName"].ToString());
            playerInfo.Offer = (int)reader["Offer"];
            playerInfo.Win = (int)reader["Win"];
            playerInfo.Total = (int)reader["Total"];
            playerInfo.Escape = (int)reader["Escape"];
            playerInfo.Skin = ((reader["Skin"] == null) ? "" : reader["Skin"].ToString());
            playerInfo.IsBanChat = (bool)reader["IsBanChat"];
            playerInfo.ReputeOffer = (int)reader["ReputeOffer"];
            playerInfo.ConsortiaRepute = (int)reader["ConsortiaRepute"];
            playerInfo.ConsortiaLevel = (int)reader["ConsortiaLevel"];
            playerInfo.StoreLevel = (int)reader["StoreLevel"];
            playerInfo.ShopLevel = (int)reader["ShopLevel"];
            playerInfo.SmithLevel = (int)reader["SmithLevel"];
            playerInfo.ConsortiaHonor = (int)reader["ConsortiaHonor"];
            playerInfo.RichesOffer = (int)reader["RichesOffer"];
            playerInfo.RichesRob = (int)reader["RichesRob"];
            playerInfo.AntiAddiction = (int)reader["AntiAddiction"];
            playerInfo.DutyLevel = (int)reader["DutyLevel"];
            playerInfo.DutyName = ((reader["DutyName"] == null) ? "" : reader["DutyName"].ToString());
            playerInfo.Right = (int)reader["Right"];
            playerInfo.ChairmanName = ((reader["ChairmanName"] == null) ? "" : reader["ChairmanName"].ToString());
            playerInfo.AddDayGP = (int)reader["AddDayGP"];
            playerInfo.AddDayOffer = (int)reader["AddDayOffer"];
            playerInfo.AddWeekGP = (int)reader["AddWeekGP"];
            playerInfo.AddWeekOffer = (int)reader["AddWeekOffer"];
            playerInfo.ConsortiaRiches = (int)reader["ConsortiaRiches"];
            playerInfo.CheckCount = (int)reader["CheckCount"];
            playerInfo.IsMarried = (bool)reader["IsMarried"];
            playerInfo.SpouseID = (int)reader["SpouseID"];
            playerInfo.SpouseName = ((reader["SpouseName"] == null) ? "" : reader["SpouseName"].ToString());
            playerInfo.MarryInfoID = (int)reader["MarryInfoID"];
            playerInfo.IsCreatedMarryRoom = (bool)reader["IsCreatedMarryRoom"];
            playerInfo.DayLoginCount = (int)reader["DayLoginCount"];
            playerInfo.PasswordTwo = ((reader["PasswordTwo"] == null) ? "" : reader["PasswordTwo"].ToString());
            playerInfo.SelfMarryRoomID = (int)reader["SelfMarryRoomID"];
            playerInfo.IsGotRing = (bool)reader["IsGotRing"];
            playerInfo.Rename = (bool)reader["Rename"];
            playerInfo.ConsortiaRename = (bool)reader["ConsortiaRename"];
            playerInfo.IsDirty = false;
            playerInfo.IsFirst = (int)reader["IsFirst"];
            playerInfo.Nimbus = (int)reader["Nimbus"];
            playerInfo.LastAward = (DateTime)reader["LastAward"];
            playerInfo.GiftToken = (int)reader["GiftToken"];
            playerInfo.QuestSite = ((reader["QuestSite"] == null) ? new byte[200] : ((byte[])reader["QuestSite"]));
            playerInfo.PvePermission = ((reader["PvePermission"] == null) ? "" : reader["PvePermission"].ToString());
            playerInfo.FightPower = (int)reader["FightPower"];
            playerInfo.PasswordQuest1 = ((reader["PasswordQuestion1"] == null) ? "" : reader["PasswordQuestion1"].ToString());
            playerInfo.PasswordQuest2 = ((reader["PasswordQuestion2"] == null) ? "" : reader["PasswordQuestion2"].ToString());
            PlayerInfo player = playerInfo;
            PlayerInfo info2 = player;
            if ((DateTime)reader["LastFindDate"] != DateTime.Today.Date)
            {
                info2.FailedPasswordAttemptCount = 5;
            }
            else
            {
                info2.FailedPasswordAttemptCount = (int)reader["FailedPasswordAttemptCount"];
            }
            player.AnswerSite = (int)reader["AnswerSite"];
            player.medal = (int)reader["Medal"];
            player.ChatCount = (int)reader["ChatCount"];
            player.SpaPubGoldRoomLimit = (int)reader["SpaPubGoldRoomLimit"];
            player.LastSpaDate = (DateTime)reader["LastSpaDate"];
            player.FightLabPermission = (string)reader["FightLabPermission"];
            player.SpaPubMoneyRoomLimit = (int)reader["SpaPubMoneyRoomLimit"];
            player.IsInSpaPubGoldToday = (bool)reader["IsInSpaPubGoldToday"];
            player.IsInSpaPubMoneyToday = (bool)reader["IsInSpaPubMoneyToday"];
            player.AchievementPoint = (int)reader["AchievementPoint"];
            player.LastWeekly = (DateTime)reader["LastWeekly"];
            player.LastWeeklyVersion = (int)reader["LastWeeklyVersion"];
            player.badgeID = (int)reader["BadgeID"];
            player.typeVIP = Convert.ToByte(reader["typeVIP"]);
            player.VIPLevel = (int)reader["VIPLevel"];
            player.VIPExp = (int)reader["VIPExp"];
            player.VIPExpireDay = (DateTime)reader["VIPExpireDay"];
            player.VIPNextLevelDaysNeeded = (int)reader["VIPNextLevelDaysNeeded"];
            player.LastVIPPackTime = (DateTime)reader["LastVIPPackTime"];
            player.CanTakeVipReward = (bool)reader["CanTakeVipReward"];
            player.WeaklessGuildProgressStr = (string)reader["WeaklessGuildProgressStr"];
            player.IsOldPlayer = (bool)reader["IsOldPlayer"];
            player.LastDate = (DateTime)reader["LastDate"];
            player.VIPLastDate = (DateTime)reader["VIPLastDate"];
            player.Score = (int)reader["Score"];
            player.OptionOnOff = (int)reader["OptionOnOff"];
            player.isOldPlayerHasValidEquitAtLogin = (bool)reader["isOldPlayerHasValidEquitAtLogin"];
            player.badLuckNumber = (int)reader["badLuckNumber"];
            player.OnlineTime = (int)reader["OnlineTime"];
            player.luckyNum = (int)reader["luckyNum"];
            player.lastLuckyNumDate = (DateTime)reader["lastLuckyNumDate"];
            player.lastLuckNum = (int)reader["lastLuckNum"];
            player.IsShowConsortia = (bool)reader["IsShowConsortia"];
            player.NewDay = (DateTime)reader["NewDay"];
            player.Honor = (string)reader["Honor"];
            player.BoxGetDate = (DateTime)reader["BoxGetDate"];
            player.AlreadyGetBox = (int)reader["AlreadyGetBox"];
            player.BoxProgression = (int)reader["BoxProgression"];
            player.GetBoxLevel = (int)reader["GetBoxLevel"];
            player.IsRecharged = (bool)reader["IsRecharged"];
            player.IsGetAward = (bool)reader["IsGetAward"];
            player.apprenticeshipState = (int)reader["apprenticeshipState"];
            player.masterID = (int)reader["masterID"];
            player.masterOrApprentices = ((reader["masterOrApprentices"] == DBNull.Value) ? "" : ((string)reader["masterOrApprentices"]));
            player.graduatesCount = (int)reader["graduatesCount"];
            player.honourOfMaster = ((reader["honourOfMaster"] == DBNull.Value) ? "" : ((string)reader["honourOfMaster"]));
            player.freezesDate = ((reader["freezesDate"] == DBNull.Value) ? DateTime.Now : ((DateTime)reader["freezesDate"]));
            player.charmGP = ((reader["charmGP"] != DBNull.Value) ? ((int)reader["charmGP"]) : 0);
            player.evolutionGrade = (int)reader["evolutionGrade"];
            player.evolutionExp = (int)reader["evolutionExp"];
            player.hardCurrency = (int)reader["hardCurrency"];
            player.EliteScore = (int)reader["EliteScore"];
            player.ShopFinallyGottenTime = ((reader["ShopFinallyGottenTime"] == DBNull.Value) ? DateTime.Now.AddDays(-1.0) : ((DateTime)reader["ShopFinallyGottenTime"]));
            player.MoneyLock = ((reader["MoneyLock"] != DBNull.Value) ? ((int)reader["MoneyLock"]) : 0);
            player.LastGetEgg = (DateTime)reader["LastGetEgg"];
            player.IsFistGetPet = (bool)reader["IsFistGetPet"];
            player.LastRefreshPet = (DateTime)reader["LastRefreshPet"];
            player.petScore = (int)reader["petScore"];
            player.accumulativeLoginDays = (int)reader["accumulativeLoginDays"];
            player.accumulativeAwardDays = (int)reader["accumulativeAwardDays"];
            player.honorId = (int)reader["honorId"];
            player.damageScores = (int)reader["damageScores"];
            player.totemId = (int)reader["totemId"];
            player.myHonor = (int)reader["myHonor"];
            player.MaxBuyHonor = (int)reader["MaxBuyHonor"];
            player.necklaceExp = (int)reader["necklaceExp"];
            player.necklaceExpAdd = (int)reader["necklaceExpAdd"];
            return player;
        }

        public bool InsertMarryRoomInfo(MarryRoomInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[20]
                {
                    new SqlParameter("@ID", info.ID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                sqlParameters[0].Direction = ParameterDirection.InputOutput;
                sqlParameters[1] = new SqlParameter("@Name", info.Name);
                sqlParameters[2] = new SqlParameter("@PlayerID", info.PlayerID);
                sqlParameters[3] = new SqlParameter("@PlayerName", info.PlayerName);
                sqlParameters[4] = new SqlParameter("@GroomID", info.GroomID);
                sqlParameters[5] = new SqlParameter("@GroomName", info.GroomName);
                sqlParameters[6] = new SqlParameter("@BrideID", info.BrideID);
                sqlParameters[7] = new SqlParameter("@BrideName", info.BrideName);
                sqlParameters[8] = new SqlParameter("@Pwd", info.Pwd);
                sqlParameters[9] = new SqlParameter("@AvailTime", info.AvailTime);
                sqlParameters[10] = new SqlParameter("@MaxCount", info.MaxCount);
                sqlParameters[11] = new SqlParameter("@GuestInvite", info.GuestInvite);
                sqlParameters[12] = new SqlParameter("@MapIndex", info.MapIndex);
                sqlParameters[13] = new SqlParameter("@BeginTime", info.BeginTime);
                sqlParameters[14] = new SqlParameter("@BreakTime", info.BreakTime);
                sqlParameters[15] = new SqlParameter("@RoomIntroduction", info.RoomIntroduction);
                sqlParameters[16] = new SqlParameter("@ServerID", info.ServerID);
                sqlParameters[17] = new SqlParameter("@IsHymeneal", info.IsHymeneal);
                sqlParameters[18] = new SqlParameter("@IsGunsaluteUsed", info.IsGunsaluteUsed);
                sqlParameters[19] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[19].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Insert_Marry_Room_Info", sqlParameters);
                flag = (int)sqlParameters[19].Value == 0;
                if (flag)
                {
                    info.ID = (int)sqlParameters[0].Value;
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("InsertMarryRoomInfo", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool InsertPlayerMarryApply(MarryApplyInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[7]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@ApplyUserID", info.ApplyUserID),
                    new SqlParameter("@ApplyUserName", info.ApplyUserName),
                    new SqlParameter("@ApplyType", info.ApplyType),
                    new SqlParameter("@ApplyResult", info.ApplyResult),
                    new SqlParameter("@LoveProclamation", info.LoveProclamation),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[6].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Insert_Marry_Apply", sqlParameters);
                flag = (int)sqlParameters[6].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("InsertPlayerMarryApply", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool InsertUserTexpInfo(TexpInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[10]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@attTexpExp", info.attTexpExp),
                    new SqlParameter("@defTexpExp", info.defTexpExp),
                    new SqlParameter("@hpTexpExp", info.hpTexpExp),
                    new SqlParameter("@lukTexpExp", info.lukTexpExp),
                    new SqlParameter("@spdTexpExp", info.spdTexpExp),
                    new SqlParameter("@texpCount", info.texpCount),
                    new SqlParameter("@texpTaskCount", info.texpTaskCount),
                    new SqlParameter("@texpTaskDate", info.texpTaskDate.ToString("yyyy-MM-dd HH:mm:ss")),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[9].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UserTexp_Add", sqlParameters);
                flag = (int)sqlParameters[9].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("InsertTexpInfo", exception);
                    return flag;
                }
                return flag;
            }
        }

        public int PullDown(int activeID, string awardID, int userID, ref string msg)
        {
            int result = 1;
            try
            {
                SqlParameter[] para = new SqlParameter[4];
                para[0] = new SqlParameter("@ActiveID", activeID);
                para[1] = new SqlParameter("@AwardID", awardID);
                para[2] = new SqlParameter("@UserID", userID);
                para[3] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[3].Direction = ParameterDirection.ReturnValue;
                if (db.RunProcedure("SP_Active_PullDown", para))
                {
                    result = (int)para[3].Value;
                    switch (result)
                    {
                        case 0:
                            //msg = "ActiveBussiness.Msg0";
                            msg = "Nhận lãnh thành công, vật phẩm đã gửi đến thư người dùng.";
                            break;
                        case 1:
                            //msg = "ActiveBussiness.Msg1";
                            msg = "Lỗi không xác định.";
                            break;
                        case 2:
                            //msg = "ActiveBussiness.Msg2";
                            msg = "Tên người dùngkhông tồn tại.";
                            break;
                        case 3:
                            //msg = "ActiveBussiness.Msg3";
                            msg = "Nhận vật phẩm  thất bại.";
                            break;
                        case 4:
                            //msg = "ActiveBussiness.Msg4";
                            msg = "Số này không tồn tại, hãy kiểm tra lại.";
                            break;
                        case 5:
                            //msg = "ActiveBussiness.Msg5";
                            msg = "Số này đã nhận thưởng, không thể nhận nữa.";
                            break;
                        case 6:
                            //msg = "ActiveBussiness.Msg6";
                            msg = "Bạn đã nhận phần thưởng này rồi";
                            break;
                        case 7:
                            //msg = "ActiveBussiness.Msg7";
                            msg = "Hoạt động chưa bắt đầu.";
                            break;
                        case 8:
                            //msg = "ActiveBussiness.Msg8";
                            msg = "Hoạt động đã quá hạn.";
                            break;
                        default:
                            //msg = "ActiveBussiness.Msg9";
                            msg = "Nhận thưởng thất bại.";
                            break;
                    }
                }

            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            return result;
        }

        public bool AddActiveNumber(string AwardID, int ActiveID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@AwardID", AwardID),
                    new SqlParameter("@ActiveID", ActiveID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Active_Number_Add", sqlParameters);
                flag = (int)sqlParameters[2].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public PlayerInfo LoginGame(string username, string password)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserName", username),
                    new SqlParameter("@Password", password)
                };
                db.GetReader(ref resultDataReader, "SP_Users_Login", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitPlayerInfo(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerInfo LoginGame(string username, ref int isFirst, ref bool isExist, ref bool isError, bool firstValidate, ref DateTime forbidDate, string nickname)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[4]
                {
                    new SqlParameter("@UserName", username),
                    new SqlParameter("@Password", ""),
                    new SqlParameter("@FirstValidate", firstValidate),
                    new SqlParameter("@Nickname", nickname)
                };
                db.GetReader(ref resultDataReader, "SP_Users_LoginWeb", sqlParameters);
                if (resultDataReader.Read())
                {
                    isFirst = (int)resultDataReader["IsFirst"];
                    isExist = (bool)resultDataReader["IsExist"];
                    forbidDate = (DateTime)resultDataReader["ForbidDate"];
                    if (isFirst > 1)
                    {
                        isFirst--;
                    }
                    return InitPlayerInfo(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                isError = true;
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public PlayerInfo LoginGame(string username, ref int isFirst, ref bool isExist, ref bool isError, bool firstValidate, ref DateTime forbidDate, ref string nickname, string ActiveIP)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[5]
                {
                    new SqlParameter("@UserName", username),
                    new SqlParameter("@Password", ""),
                    new SqlParameter("@FirstValidate", firstValidate),
                    new SqlParameter("@Nickname", nickname),
                    new SqlParameter("@ActiveIP", ActiveIP)
                };
                db.GetReader(ref resultDataReader, "SP_Users_LoginWeb", sqlParameters);
                if (resultDataReader.Read())
                {
                    isFirst = (int)resultDataReader["IsFirst"];
                    isExist = (bool)resultDataReader["IsExist"];
                    forbidDate = (DateTime)resultDataReader["ForbidDate"];
                    nickname = (string)resultDataReader["NickName"];
                    if (isFirst > 1)
                    {
                        isFirst--;
                    }
                    return InitPlayerInfo(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                isError = true;
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public bool RegisterPlayer(string userName, string passWord, string nickName, string bStyle, string gStyle, string armColor, string hairColor, string faceColor, string clothColor, string hatColor, int sex, ref string msg, int validDate)
        {
            bool flag = false;
            try
            {
                string[] strArray = bStyle.Split(',');
                string[] strArray2 = gStyle.Split(',');
                SqlParameter[] sqlParameters = new SqlParameter[21]
                {
                    new SqlParameter("@UserName", userName),
                    new SqlParameter("@PassWord", passWord),
                    new SqlParameter("@NickName", nickName),
                    new SqlParameter("@BArmID", int.Parse(strArray[0])),
                    new SqlParameter("@BHairID", int.Parse(strArray[1])),
                    new SqlParameter("@BFaceID", int.Parse(strArray[2])),
                    new SqlParameter("@BClothID", int.Parse(strArray[3])),
                    new SqlParameter("@BHatID", int.Parse(strArray[4])),
                    new SqlParameter("@GArmID", int.Parse(strArray2[0])),
                    new SqlParameter("@GHairID", int.Parse(strArray2[1])),
                    new SqlParameter("@GFaceID", int.Parse(strArray2[2])),
                    new SqlParameter("@GClothID", int.Parse(strArray2[3])),
                    new SqlParameter("@GHatID", int.Parse(strArray2[4])),
                    new SqlParameter("@ArmColor", armColor),
                    new SqlParameter("@HairColor", hairColor),
                    new SqlParameter("@FaceColor", faceColor),
                    new SqlParameter("@ClothColor", clothColor),
                    new SqlParameter("@HatColor", clothColor),
                    new SqlParameter("@Sex", sex),
                    new SqlParameter("@StyleDate", validDate),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[20].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Users_RegisterNotValidate", sqlParameters);
                int num = (int)sqlParameters[20].Value;
                flag = num == 0;
                switch (num)
                {
                    case 2:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.RegisterPlayer.Msg2");
                        return flag;
                    case 3:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.RegisterPlayer.Msg3");
                        return flag;
                    default:
                        return flag;
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool RegisterUser(string UserName, string NickName, string Password, bool Sex, int Money, int GiftToken, int Gold)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[8]
                {
                    new SqlParameter("@UserName", UserName),
                    new SqlParameter("@Password", Password),
                    new SqlParameter("@NickName", NickName),
                    new SqlParameter("@Sex", Sex),
                    new SqlParameter("@Money", Money),
                    new SqlParameter("@GiftToken", GiftToken),
                    new SqlParameter("@Gold", Gold),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[7].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Account_Register", sqlParameters);
                if ((int)sqlParameters[7].Value == 0)
                {
                    flag = true;
                    return flag;
                }
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init Register", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool RegisterUserInfo(UserInfo userinfo)
        {
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[6]
                {
                    new SqlParameter("@UserID", userinfo.UserID),
                    new SqlParameter("@UserEmail", userinfo.UserEmail),
                    new SqlParameter("@UserPhone", (userinfo.UserPhone == null) ? string.Empty : userinfo.UserPhone),
                    new SqlParameter("@UserOther1", (userinfo.UserOther1 == null) ? string.Empty : userinfo.UserOther1),
                    new SqlParameter("@UserOther2", (userinfo.UserOther2 == null) ? string.Empty : userinfo.UserOther2),
                    new SqlParameter("@UserOther3", (userinfo.UserOther3 == null) ? string.Empty : userinfo.UserOther3)
                };
                return db.RunProcedure("SP_User_Info_Add", sqlParameters);
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            return false;
        }

        public PlayerInfo ReLoadPlayer(int ID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ID", ID)
                };
                db.GetReader(ref resultDataReader, "SP_Users_Reload", sqlParameters);
                if (resultDataReader.Read())
                {
                    return InitPlayerInfo(resultDataReader);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public bool RemoveIsArrange(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_RemoveIsArrange", sqlParameters);
                flag = (int)sqlParameters[1].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_RemoveIsArrange", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool RemoveTreasureDataByUser(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_RemoveTreasureDataByUser", sqlParameters);
                flag = (int)sqlParameters[1].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_RemoveTreasureDataByUser", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool RenameNick(string userName, string nickName, string newNickName)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[4];
                para[0] = new SqlParameter("@UserName", userName);
                para[1] = new SqlParameter("@NickName", nickName);
                para[2] = new SqlParameter("@NewNickName", newNickName);
                para[3] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[3].Direction = ParameterDirection.ReturnValue;

                result = db.RunProcedure("SP_Users_RenameByCard", para);
                int returnValue = (int)para[3].Value;
                result = returnValue == 0;
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("RenameNick", e);
            }
            return result;
        }


        public bool RenameNick(string userName, string nickName, string newNickName, ref string msg)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[4];
                para[0] = new SqlParameter("@UserName", userName);
                para[1] = new SqlParameter("@NickName", nickName);
                para[2] = new SqlParameter("@NewNickName", newNickName);
                para[3] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[3].Direction = ParameterDirection.ReturnValue;

                result = db.RunProcedure("SP_Users_RenameNick", para);
                int returnValue = (int)para[3].Value;
                result = returnValue == 0;
                switch (returnValue)
                {
                    case 4:
                    case 5:
                        msg = LanguageMgr.GetTranslation(" tên nhân vật đã tồn tại.");
                        break;
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("RenameNick", e);
            }
            return result;
        }

        public bool ChangeSex(int UserId, bool newSex)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[3]
                {
                    new SqlParameter("@UserId", UserId),
                    new SqlParameter("@Sex", newSex),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                para[2].Direction = ParameterDirection.ReturnValue;
                result = db.RunProcedure("SP_Users_ChangSexByCard", para);
                int returnValue = (int)para[2].Value;
                result = returnValue == 0;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_Users_ChangSexByCard ", e);
                }
            }
            return result;
        }

        public bool ResetCommunalActive(int ActiveID, bool IsReset)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@ActiveID", ActiveID),
                    new SqlParameter("@IsReset", IsReset),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_ReCommunalActive", sqlParameters);
                flag = (int)sqlParameters[2].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init CommunalActive", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool ResetDragonBoat()
        {
            bool flag = false;
            try
            {
                flag = db.RunProcedure("SP_ReDragonBoat_Data");
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init ResetDragonBoat", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool SaveBuffer(BufferInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[9]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@Type", info.Type),
                    new SqlParameter("@BeginDate", info.BeginDate),
                    new SqlParameter("@Data", (info.Data == null) ? "" : info.Data),
                    new SqlParameter("@IsExist", info.IsExist),
                    new SqlParameter("@ValidDate", info.ValidDate),
                    new SqlParameter("@ValidCount", info.ValidCount),
                    new SqlParameter("@Value", info.Value),
                    new SqlParameter("@TemplateID", info.TemplateID)
                };
                flag = db.RunProcedure("SP_User_Buff_Add", sqlParameters);
                info.IsDirty = false;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool SaveConsortiaBuffer(ConsortiaBufferInfo info)
        {
            bool flag = false;
            try
            {
                flag = db.RunProcedure("SP_User_Consortia_Buff_Add", new SqlParameter[7]
                {
                    new SqlParameter("@ConsortiaID", info.ConsortiaID),
                    new SqlParameter("@BufferID", info.BufferID),
                    new SqlParameter("@IsOpen", info.IsOpen ? 1 : 0),
                    new SqlParameter("@BeginDate", info.BeginDate),
                    new SqlParameter("@ValidDate", info.ValidDate),
                    new SqlParameter("@Type ", info.Type),
                    new SqlParameter("@Value", info.Value)
                });
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool SavePlayerMarryNotice(MarryApplyInfo info, int answerId, ref int id)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[9]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@ApplyUserID", info.ApplyUserID),
                    new SqlParameter("@ApplyUserName", info.ApplyUserName),
                    new SqlParameter("@ApplyType", info.ApplyType),
                    new SqlParameter("@ApplyResult", info.ApplyResult),
                    new SqlParameter("@LoveProclamation", info.LoveProclamation),
                    new SqlParameter("@AnswerId", answerId),
                    new SqlParameter("@ouototal", SqlDbType.Int),
                    null
                };
                sqlParameters[7].Direction = ParameterDirection.Output;
                sqlParameters[8] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[8].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Insert_Marry_Notice", sqlParameters);
                id = (int)sqlParameters[7].Value;
                flag = (int)sqlParameters[8].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SavePlayerMarryNotice", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool ScanAuction(ref string noticeUserID, double cess)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@NoticeUserID", SqlDbType.NVarChar, 4000),
                    null
                };
                SqlParameters[0].Direction = ParameterDirection.Output;
                SqlParameters[1] = new SqlParameter("@Cess", cess);
                db.RunProcedure("SP_Auction_Scan", SqlParameters);
                noticeUserID = SqlParameters[0].Value.ToString();
                flag = true;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool ScanMail(ref string noticeUserID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@NoticeUserID", SqlDbType.NVarChar, 4000)
                };
                sqlParameters[0].Direction = ParameterDirection.Output;
                db.RunProcedure("SP_Mail_Scan", sqlParameters);
                noticeUserID = sqlParameters[0].Value.ToString();
                flag = true;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool SendMail(MailInfo mail)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[29];
                sqlParameters[0] = new SqlParameter("@ID", mail.ID);
                sqlParameters[0].Direction = ParameterDirection.Output;
                sqlParameters[1] = new SqlParameter("@Annex1", (mail.Annex1 == null) ? "" : mail.Annex1);
                sqlParameters[2] = new SqlParameter("@Annex2", (mail.Annex2 == null) ? "" : mail.Annex2);
                sqlParameters[3] = new SqlParameter("@Content", (mail.Content == null) ? "" : mail.Content);
                sqlParameters[4] = new SqlParameter("@Gold", mail.Gold);
                sqlParameters[5] = new SqlParameter("@IsExist", true);
                sqlParameters[6] = new SqlParameter("@Money", mail.Money);
                sqlParameters[7] = new SqlParameter("@Receiver", (mail.Receiver == null) ? "" : mail.Receiver);
                sqlParameters[8] = new SqlParameter("@ReceiverID", mail.ReceiverID);
                sqlParameters[9] = new SqlParameter("@Sender", (mail.Sender == null) ? "" : mail.Sender);
                sqlParameters[10] = new SqlParameter("@SenderID", mail.SenderID);
                sqlParameters[11] = new SqlParameter("@Title", (mail.Title == null) ? "" : mail.Title);
                sqlParameters[12] = new SqlParameter("@IfDelS", false);
                sqlParameters[13] = new SqlParameter("@IsDelete", false);
                sqlParameters[14] = new SqlParameter("@IsDelR", false);
                sqlParameters[15] = new SqlParameter("@IsRead", false);
                sqlParameters[16] = new SqlParameter("@SendTime", DateTime.Now);
                sqlParameters[17] = new SqlParameter("@Type", mail.Type);
                sqlParameters[18] = new SqlParameter("@Annex1Name", (mail.Annex1Name == null) ? "" : mail.Annex1Name);
                sqlParameters[19] = new SqlParameter("@Annex2Name", (mail.Annex2Name == null) ? "" : mail.Annex2Name);
                sqlParameters[20] = new SqlParameter("@Annex3", (mail.Annex3 == null) ? "" : mail.Annex3);
                sqlParameters[21] = new SqlParameter("@Annex4", (mail.Annex4 == null) ? "" : mail.Annex4);
                sqlParameters[22] = new SqlParameter("@Annex5", (mail.Annex5 == null) ? "" : mail.Annex5);
                sqlParameters[23] = new SqlParameter("@Annex3Name", (mail.Annex3Name == null) ? "" : mail.Annex3Name);
                sqlParameters[24] = new SqlParameter("@Annex4Name", (mail.Annex4Name == null) ? "" : mail.Annex4Name);
                sqlParameters[25] = new SqlParameter("@Annex5Name", (mail.Annex5Name == null) ? "" : mail.Annex5Name);
                sqlParameters[26] = new SqlParameter("@ValidDate", mail.ValidDate);
                sqlParameters[27] = new SqlParameter("@AnnexRemark", (mail.AnnexRemark == null) ? "" : mail.AnnexRemark);
                sqlParameters[28] = new SqlParameter("@GiftToken", mail.GiftToken);
                flag = db.RunProcedure("SP_Mail_Send", sqlParameters);
                mail.ID = (int)sqlParameters[0].Value;
                using CenterServiceClient client = new CenterServiceClient();
                client.MailNotice(mail.ReceiverID);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool SendMailAndItem(MailInfo mail, ItemInfo item, ref int returnValue)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[34]
                {
                    new SqlParameter("@ItemID", item.ItemID),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@TemplateID", item.TemplateID),
                    new SqlParameter("@Place", item.Place),
                    new SqlParameter("@AgilityCompose", item.AgilityCompose),
                    new SqlParameter("@AttackCompose", item.AttackCompose),
                    new SqlParameter("@BeginDate", item.BeginDate),
                    new SqlParameter("@Color", (item.Color == null) ? "" : item.Color),
                    new SqlParameter("@Count", item.Count),
                    new SqlParameter("@DefendCompose", item.DefendCompose),
                    new SqlParameter("@IsBinds", item.IsBinds),
                    new SqlParameter("@IsExist", item.IsExist),
                    new SqlParameter("@IsJudge", item.IsJudge),
                    new SqlParameter("@LuckCompose", item.LuckCompose),
                    new SqlParameter("@StrengthenLevel", item.StrengthenLevel),
                    new SqlParameter("@ValidDate", item.ValidDate),
                    new SqlParameter("@BagType", item.BagType),
                    new SqlParameter("@ID", mail.ID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                sqlParameters[17].Direction = ParameterDirection.Output;
                sqlParameters[18] = new SqlParameter("@Annex1", (mail.Annex1 == null) ? "" : mail.Annex1);
                sqlParameters[19] = new SqlParameter("@Annex2", (mail.Annex2 == null) ? "" : mail.Annex2);
                sqlParameters[20] = new SqlParameter("@Content", (mail.Content == null) ? "" : mail.Content);
                sqlParameters[21] = new SqlParameter("@Gold", mail.Gold);
                sqlParameters[22] = new SqlParameter("@Money", mail.Money);
                sqlParameters[23] = new SqlParameter("@Receiver", (mail.Receiver == null) ? "" : mail.Receiver);
                sqlParameters[24] = new SqlParameter("@ReceiverID", mail.ReceiverID);
                sqlParameters[25] = new SqlParameter("@Sender", (mail.Sender == null) ? "" : mail.Sender);
                sqlParameters[26] = new SqlParameter("@SenderID", mail.SenderID);
                sqlParameters[27] = new SqlParameter("@Title", (mail.Title == null) ? "" : mail.Title);
                sqlParameters[28] = new SqlParameter("@IfDelS", false);
                sqlParameters[29] = new SqlParameter("@IsDelete", false);
                sqlParameters[30] = new SqlParameter("@IsDelR", false);
                sqlParameters[31] = new SqlParameter("@IsRead", false);
                sqlParameters[32] = new SqlParameter("@SendTime", DateTime.Now);
                sqlParameters[33] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[33].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Admin_SendUserItem", sqlParameters);
                returnValue = (int)sqlParameters[33].Value;
                flag = returnValue == 0;
                if (!flag)
                {
                    return flag;
                }
                using CenterServiceClient client = new CenterServiceClient();
                client.MailNotice(mail.ReceiverID);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public int SendMailAndItem(string title, string content, int userID, int gold, int money, string param)
        {
            int num = 1;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[8]
                {
                    new SqlParameter("@Title", title),
                    new SqlParameter("@Content", content),
                    new SqlParameter("@UserID", userID),
                    new SqlParameter("@Gold", gold),
                    new SqlParameter("@Money", money),
                    new SqlParameter("@GiftToken", SqlDbType.BigInt),
                    new SqlParameter("@Param", param),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[7].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Admin_SendAllItem", sqlParameters);
                num = (int)sqlParameters[7].Value;
                if (num != 0)
                {
                    return num;
                }
                using CenterServiceClient client = new CenterServiceClient();
                client.MailNotice(userID);
                return num;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return num;
                }
                return num;
            }
        }

        public int SendMailAndItem(string title, string content, int UserID, int templateID, int count, int validDate, int gold, int money, int StrengthenLevel, int AttackCompose, int DefendCompose, int AgilityCompose, int LuckCompose, bool isBinds)
        {
            MailInfo mail = new MailInfo
            {
                Annex1 = "",
                Content = title,
                Gold = gold,
                Money = money,
                Receiver = "",
                ReceiverID = UserID,
                Sender = "Administrators",
                SenderID = 0,
                Title = content
            };
            ItemInfo item = new ItemInfo(null)
            {
                AgilityCompose = AgilityCompose,
                AttackCompose = AttackCompose,
                BeginDate = DateTime.Now,
                Color = "",
                DefendCompose = DefendCompose,
                IsDirty = false,
                IsExist = true,
                IsJudge = true,
                LuckCompose = LuckCompose,
                StrengthenLevel = StrengthenLevel,
                TemplateID = templateID,
                ValidDate = validDate,
                Count = count,
                IsBinds = isBinds
            };
            int returnValue = 1;
            SendMailAndItem(mail, item, ref returnValue);
            return returnValue;
        }

        public int SendMailAndItemByNickName(string title, string content, string nickName, int gold, int money, string param)
        {
            PlayerInfo userSingleByNickName = GetUserSingleByNickName(nickName);
            if (userSingleByNickName != null)
            {
                return SendMailAndItem(title, content, userSingleByNickName.ID, gold, money, param);
            }
            return 2;
        }

        public int SendMailAndItemByNickName(string title, string content, string NickName, int templateID, int count, int validDate, int gold, int money, int StrengthenLevel, int AttackCompose, int DefendCompose, int AgilityCompose, int LuckCompose, bool isBinds)
        {
            PlayerInfo userSingleByNickName = GetUserSingleByNickName(NickName);
            if (userSingleByNickName != null)
            {
                return SendMailAndItem(title, content, userSingleByNickName.ID, templateID, count, validDate, gold, money, StrengthenLevel, AttackCompose, DefendCompose, AgilityCompose, LuckCompose, isBinds);
            }
            return 2;
        }

        public int SendMailAndItemByUserName(string title, string content, string userName, int gold, int money, string param)
        {
            PlayerInfo userSingleByUserName = GetUserSingleByUserName(userName);
            if (userSingleByUserName != null)
            {
                return SendMailAndItem(title, content, userSingleByUserName.ID, gold, money, param);
            }
            return 2;
        }

        public int SendMailAndItemByUserName(string title, string content, string userName, int templateID, int count, int validDate, int gold, int money, int StrengthenLevel, int AttackCompose, int DefendCompose, int AgilityCompose, int LuckCompose, bool isBinds)
        {
            PlayerInfo userSingleByUserName = GetUserSingleByUserName(userName);
            if (userSingleByUserName != null)
            {
                return SendMailAndItem(title, content, userSingleByUserName.ID, templateID, count, validDate, gold, money, StrengthenLevel, AttackCompose, DefendCompose, AgilityCompose, LuckCompose, isBinds);
            }
            return 2;
        }

        public bool SendMailAndMoney(MailInfo mail, ref int returnValue)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[18]
                {
                    new SqlParameter("@ID", mail.ID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                sqlParameters[0].Direction = ParameterDirection.Output;
                sqlParameters[1] = new SqlParameter("@Annex1", (mail.Annex1 == null) ? "" : mail.Annex1);
                sqlParameters[2] = new SqlParameter("@Annex2", (mail.Annex2 == null) ? "" : mail.Annex2);
                sqlParameters[3] = new SqlParameter("@Content", (mail.Content == null) ? "" : mail.Content);
                sqlParameters[4] = new SqlParameter("@Gold", mail.Gold);
                sqlParameters[5] = new SqlParameter("@IsExist", true);
                sqlParameters[6] = new SqlParameter("@Money", mail.Money);
                sqlParameters[7] = new SqlParameter("@Receiver", (mail.Receiver == null) ? "" : mail.Receiver);
                sqlParameters[8] = new SqlParameter("@ReceiverID", mail.ReceiverID);
                sqlParameters[9] = new SqlParameter("@Sender", (mail.Sender == null) ? "" : mail.Sender);
                sqlParameters[10] = new SqlParameter("@SenderID", mail.SenderID);
                sqlParameters[11] = new SqlParameter("@Title", (mail.Title == null) ? "" : mail.Title);
                sqlParameters[12] = new SqlParameter("@IfDelS", false);
                sqlParameters[13] = new SqlParameter("@IsDelete", false);
                sqlParameters[14] = new SqlParameter("@IsDelR", false);
                sqlParameters[15] = new SqlParameter("@IsRead", false);
                sqlParameters[16] = new SqlParameter("@SendTime", DateTime.Now);
                sqlParameters[17] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameters[17].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Admin_SendUserMoney", sqlParameters);
                returnValue = (int)sqlParameters[17].Value;
                flag = returnValue == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool Test(string DutyName)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@DutyName", DutyName)
                };
                flag = db.RunProcedure("SP_Test1", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateAuction(AuctionInfo info, double cess)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[17]
                {
                    new SqlParameter("@AuctionID", info.AuctionID),
                    new SqlParameter("@AuctioneerID", info.AuctioneerID),
                    new SqlParameter("@AuctioneerName", (info.AuctioneerName == null) ? "" : info.AuctioneerName),
                    new SqlParameter("@BeginDate", info.BeginDate),
                    new SqlParameter("@BuyerID", info.BuyerID),
                    new SqlParameter("@BuyerName", (info.BuyerName == null) ? "" : info.BuyerName),
                    new SqlParameter("@IsExist", info.IsExist),
                    new SqlParameter("@ItemID", info.ItemID),
                    new SqlParameter("@Mouthful", info.Mouthful),
                    new SqlParameter("@PayType", info.PayType),
                    new SqlParameter("@Price", info.Price),
                    new SqlParameter("@Rise", info.Rise),
                    new SqlParameter("@ValidDate", info.ValidDate),
                    new SqlParameter("@Name", info.Name),
                    new SqlParameter("@Category", info.Category),
                    null,
                    new SqlParameter("@Cess", cess)
                };
                SqlParameters[15] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[15].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Auction_Update", SqlParameters);
                flag = (int)SqlParameters[15].Value == 0;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateUsersEventProcess(EventRewardProcessInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[5]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@ActiveType", info.ActiveType),
                    new SqlParameter("@Conditions", info.Conditions),
                    new SqlParameter("@AwardGot", info.AwardGot),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[4].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateUsersEventProcess", sqlParameters);
                flag = (int)sqlParameters[4].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                BaseBussiness.log.Error("SP_UpdateUsersEventProcess", exception);
                return flag;
            }
        }

        public bool UpdateBreakTimeWhereServerStop()
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[0].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Update_Marry_Room_Info_Sever_Stop", sqlParameters);
                flag = (int)sqlParameters[0].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdateBreakTimeWhereServerStop", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateBuyStore(int storeId)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@StoreID", storeId)
                };
                flag = db.RunProcedure("SP_Update_Buy_Store", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_Update_Buy_Store", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool ResetQuests(int UserID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", UserID)
                };
                flag = db.RunProcedure("SP_Quest_Reset", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_Quest_Reset", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateCards(UsersCardInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[19]
                {
                    new SqlParameter("@CardID", item.CardID),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@TemplateID", item.TemplateID),
                    new SqlParameter("@Place", item.Place),
                    new SqlParameter("@Count", item.Count),
                    new SqlParameter("@Attack", item.Attack),
                    new SqlParameter("@Defence", item.Defence),
                    new SqlParameter("@Agility", item.Agility),
                    new SqlParameter("@Luck", item.Luck),
                    new SqlParameter("@Guard", item.Guard),
                    new SqlParameter("@Damage", item.Damage),
                    new SqlParameter("@Level", item.Level),
                    new SqlParameter("@CardGP", item.CardGP),
                    null,
                    new SqlParameter("@AttackReset", item.AttackReset),
                    new SqlParameter("@DefenceReset", item.DefenceReset),
                    new SqlParameter("@AgilityReset", item.AgilityReset),
                    new SqlParameter("@LuckReset", item.LuckReset),
                    new SqlParameter("@isFirstGet", item.isFirstGet)
                };
                SqlParameters[13] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[13].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateUserCard", SqlParameters);
                flag = (int)SqlParameters[13].Value == 0;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateUserCard", ex);
                    return flag;
                }
                return flag;
            }
        }

        public int Updatecash(string UserName, int cash)
        {
            int num = 3;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@UserName", UserName),
                    new SqlParameter("@Cash", cash),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Update_Cash", sqlParameters);
                num = (int)sqlParameters[2].Value;
                return num;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return num;
                }
                return num;
            }
        }

        public bool UpdateDbAchievementDataInfo(AchievementDataInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[4]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@AchievementID", info.AchievementID),
                    new SqlParameter("@IsComplete", info.IsComplete),
                    new SqlParameter("@CompletedDate", info.CompletedDate)
                };
                result = db.RunProcedure("SP_Achievement_Data_Add", para);
                info.IsDirty = false;
                return result;
            }
            catch (Exception e)
            {
                BaseBussiness.log.Error("Init_UpdateDbAchievementDataInfo", e);
                return result;
            }
        }

        public List<AchievementDataInfo> GetUserAchievementData(int userID)
        {
            List<AchievementDataInfo> infos = new List<AchievementDataInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = userID;
                db.GetReader(ref reader, "SP_Achievement_Data_All", para);
                while (reader.Read())
                {
                    infos.Add(new AchievementDataInfo
                    {
                        UserID = (int)reader["UserID"],
                        AchievementID = (int)reader["AchievementID"],
                        IsComplete = (bool)reader["IsComplete"],
                        CompletedDate = (DateTime)reader["CompletedDate"],
                        IsDirty = false
                    });
                }
                return infos;
            }
            catch (Exception e)
            {
                BaseBussiness.log.Error("Init_GetUserAchievement", e);
                return infos;
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
        }

        public List<AchievementDataInfo> GetUserAchievementData(int userID, int id)
        {
            List<AchievementDataInfo> infos = new List<AchievementDataInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4),
                    new SqlParameter("@AchievementID", id)
                };
                para[0].Value = userID;
                db.GetReader(ref reader, "SP_Achievement_Data_Single", para);
                while (reader.Read())
                {
                    infos.Add(new AchievementDataInfo
                    {
                        UserID = (int)reader["UserID"],
                        AchievementID = (int)reader["AchievementID"],
                        IsComplete = (bool)reader["IsComplete"],
                        CompletedDate = (DateTime)reader["CompletedDate"],
                        IsDirty = false
                    });
                }
                return infos;
            }
            catch (Exception e)
            {
                BaseBussiness.log.Error("Init_GetUserAchievementSingle", e);
                return infos;
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
        }

        public List<UsersRecordInfo> GetUserRecord(int userID)
        {
            List<UsersRecordInfo> infos = new List<UsersRecordInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = userID;
                db.GetReader(ref reader, "SP_Users_Record_All", para);
                while (reader.Read())
                {
                    infos.Add(new UsersRecordInfo
                    {
                        UserID = (int)reader["UserID"],
                        RecordID = (int)reader["RecordID"],
                        Total = (int)reader["Total"],
                        IsDirty = false
                    });
                }
                return infos;
            }
            catch (Exception e)
            {
                BaseBussiness.log.Error("Init_GetUserRecord", e);
                return infos;
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
        }

        public bool UpdateDbUserRecord(UsersRecordInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[3]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@RecordID", info.RecordID),
                    new SqlParameter("@Total", info.Total)
                };
                result = db.RunProcedure("SP_Users_Record_Add", para);
                info.IsDirty = false;
                return result;
            }
            catch (Exception e)
            {
                BaseBussiness.log.Error("Init_UpdateDbUserRecord", e);
                return result;
            }
        }

        public bool UpdateDbQuestDataInfo(QuestDataInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[11]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@QuestID", info.QuestID),
                    new SqlParameter("@CompletedDate", info.CompletedDate),
                    new SqlParameter("@IsComplete", info.IsComplete),
                    new SqlParameter("@Condition1", (info.Condition1 > -1) ? info.Condition1 : 0),
                    new SqlParameter("@Condition2", (info.Condition2 > -1) ? info.Condition2 : 0),
                    new SqlParameter("@Condition3", (info.Condition3 > -1) ? info.Condition3 : 0),
                    new SqlParameter("@Condition4", (info.Condition4 > -1) ? info.Condition4 : 0),
                    new SqlParameter("@IsExist", info.IsExist),
                    new SqlParameter("@RepeatFinish", (info.RepeatFinish == -1) ? 1 : info.RepeatFinish),
                    new SqlParameter("@RandDobule", info.RandDobule)
                };
                flag = db.RunProcedure("SP_QuestData_Add", sqlParameters);
                info.IsDirty = false;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateFriendHelpTimes(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateFriendHelpTimes", sqlParameters);
                flag = (int)sqlParameters[1].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateFriendHelpTimes", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateGoods(ItemInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[40]
                {
                    new SqlParameter("@ItemID", item.ItemID),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@TemplateID", item.Template.TemplateID),
                    new SqlParameter("@Place", item.Place),
                    new SqlParameter("@AgilityCompose", item.AgilityCompose),
                    new SqlParameter("@AttackCompose", item.AttackCompose),
                    new SqlParameter("@BeginDate", item.BeginDate),
                    new SqlParameter("@Color", (item.Color == null) ? "" : item.Color),
                    new SqlParameter("@Count", item.Count),
                    new SqlParameter("@DefendCompose", item.DefendCompose),
                    new SqlParameter("@IsBinds", item.IsBinds),
                    new SqlParameter("@IsExist", item.IsExist),
                    new SqlParameter("@IsJudge", item.IsJudge),
                    new SqlParameter("@LuckCompose", item.LuckCompose),
                    new SqlParameter("@StrengthenLevel", item.StrengthenLevel),
                    new SqlParameter("@ValidDate", item.ValidDate),
                    new SqlParameter("@BagType", item.BagType),
                    new SqlParameter("@Skin", item.Skin),
                    new SqlParameter("@IsUsed", item.IsUsed),
                    new SqlParameter("@RemoveDate", item.RemoveDate),
                    new SqlParameter("@RemoveType", item.RemoveType),
                    new SqlParameter("@Hole1", item.Hole1),
                    new SqlParameter("@Hole2", item.Hole2),
                    new SqlParameter("@Hole3", item.Hole3),
                    new SqlParameter("@Hole4", item.Hole4),
                    new SqlParameter("@Hole5", item.Hole5),
                    new SqlParameter("@Hole6", item.Hole6),
                    new SqlParameter("@StrengthenTimes", item.StrengthenTimes),
                    new SqlParameter("@Hole5Level", item.Hole5Level),
                    new SqlParameter("@Hole5Exp", item.Hole5Exp),
                    new SqlParameter("@Hole6Level", item.Hole6Level),
                    new SqlParameter("@Hole6Exp", item.Hole6Exp),
                    new SqlParameter("@IsGold", item.IsGold),
                    new SqlParameter("@goldBeginTime", item.goldBeginTime),
                    new SqlParameter("@goldValidDate", item.goldValidDate),
                    new SqlParameter("@StrengthenExp", item.StrengthenExp),
                    new SqlParameter("@Blood", item.Blood),
                    new SqlParameter("@latentEnergyCurStr", item.latentEnergyCurStr),
                    new SqlParameter("@latentEnergyNewStr", item.latentEnergyNewStr),
                    new SqlParameter("@latentEnergyEndTime", item.latentEnergyEndTime)
                };
                flag = db.RunProcedure("SP_Users_Items_Update", sqlParameters);
                item.IsDirty = false;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateLastVIPPackTime(int ID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@UserID", ID),
                    new SqlParameter("@LastVIPPackTime", DateTime.Now.Date),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateUserLastVIPPackTime", sqlParameters);
                flag = true;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateUserLastVIPPackTime", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateMail(MailInfo mail, int oldMoney)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[30]
                {
                    new SqlParameter("@ID", mail.ID),
                    new SqlParameter("@Annex1", (mail.Annex1 == null) ? "" : mail.Annex1),
                    new SqlParameter("@Annex2", (mail.Annex2 == null) ? "" : mail.Annex2),
                    new SqlParameter("@Content", (mail.Content == null) ? "" : mail.Content),
                    new SqlParameter("@Gold", mail.Gold),
                    new SqlParameter("@IsExist", mail.IsExist),
                    new SqlParameter("@Money", mail.Money),
                    new SqlParameter("@Receiver", (mail.Receiver == null) ? "" : mail.Receiver),
                    new SqlParameter("@ReceiverID", mail.ReceiverID),
                    new SqlParameter("@Sender", (mail.Sender == null) ? "" : mail.Sender),
                    new SqlParameter("@SenderID", mail.SenderID),
                    new SqlParameter("@Title", (mail.Title == null) ? "" : mail.Title),
                    new SqlParameter("@IfDelS", false),
                    new SqlParameter("@IsDelete", false),
                    new SqlParameter("@IsDelR", false),
                    new SqlParameter("@IsRead", mail.IsRead),
                    new SqlParameter("@SendTime", mail.SendTime),
                    new SqlParameter("@Type", mail.Type),
                    new SqlParameter("@OldMoney", oldMoney),
                    new SqlParameter("@ValidDate", mail.ValidDate),
                    new SqlParameter("@Annex1Name", mail.Annex1Name),
                    new SqlParameter("@Annex2Name", mail.Annex2Name),
                    new SqlParameter("@Result", SqlDbType.Int),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                sqlParameters[22].Direction = ParameterDirection.ReturnValue;
                sqlParameters[23] = new SqlParameter("@Annex3", (mail.Annex3 == null) ? "" : mail.Annex3);
                sqlParameters[24] = new SqlParameter("@Annex4", (mail.Annex4 == null) ? "" : mail.Annex4);
                sqlParameters[25] = new SqlParameter("@Annex5", (mail.Annex5 == null) ? "" : mail.Annex5);
                sqlParameters[26] = new SqlParameter("@Annex3Name", (mail.Annex3Name == null) ? "" : mail.Annex3Name);
                sqlParameters[27] = new SqlParameter("@Annex4Name", (mail.Annex4Name == null) ? "" : mail.Annex4Name);
                sqlParameters[28] = new SqlParameter("@Annex5Name", (mail.Annex5Name == null) ? "" : mail.Annex5Name);
                sqlParameters[29] = new SqlParameter("GiftToken", mail.GiftToken);
                db.RunProcedure("SP_Mail_Update", sqlParameters);
                flag = (int)sqlParameters[22].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateMarryInfo(MarryInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[6]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@IsPublishEquip", info.IsPublishEquip),
                    new SqlParameter("@Introduction", info.Introduction),
                    new SqlParameter("@RegistTime", info.RegistTime.ToString("yyyy-MM-dd HH:mm:ss")),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[5].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_MarryInfo_Update", sqlParameters);
                flag = (int)sqlParameters[5].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateMarryRoomInfo(MarryRoomInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[9]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@AvailTime", info.AvailTime),
                    new SqlParameter("@BreakTime", info.BreakTime),
                    new SqlParameter("@roomIntroduction", info.RoomIntroduction),
                    new SqlParameter("@isHymeneal", info.IsHymeneal),
                    new SqlParameter("@Name", info.Name),
                    new SqlParameter("@Pwd", info.Pwd),
                    new SqlParameter("@IsGunsaluteUsed", info.IsGunsaluteUsed),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[8].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Update_Marry_Room_Info", sqlParameters);
                flag = (int)sqlParameters[8].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdateMarryRoomInfo", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePassWord(int userID, string password)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", userID),
                    new SqlParameter("@Password", password)
                };
                flag = db.RunProcedure("SP_Users_UpdatePassword", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePasswordInfo(int userID, string PasswordQuestion1, string PasswordAnswer1, string PasswordQuestion2, string PasswordAnswer2, int Count)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[6]
                {
                    new SqlParameter("@UserID", userID),
                    new SqlParameter("@PasswordQuestion1", PasswordQuestion1),
                    new SqlParameter("@PasswordAnswer1", PasswordAnswer1),
                    new SqlParameter("@PasswordQuestion2", PasswordQuestion2),
                    new SqlParameter("@PasswordAnswer2", PasswordAnswer2),
                    new SqlParameter("@FailedPasswordAttemptCount", Count)
                };
                flag = db.RunProcedure("SP_Users_Password_Add", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePasswordTwo(int userID, string passwordTwo)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", userID),
                    new SqlParameter("@PasswordTwo", passwordTwo)
                };
                flag = db.RunProcedure("SP_Users_UpdatePasswordTwo", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePlayer(PlayerInfo player)
        {
            bool flag = false;
            SqlParameter[] sqlParameters2 = new SqlParameter[86];
            try
            {
                if (player.Grade < 1)
                {
                    return flag;
                }
                if (player.ID <= 0)
                {
                    return flag;
                }
                SqlParameter[] para = new SqlParameter[86];
                para[0] = new SqlParameter("@UserID", player.ID);
                para[1] = new SqlParameter("@Attack", player.Attack);
                para[2] = new SqlParameter("@Colors", (player.Colors == null) ? "" : player.Colors);
                para[3] = new SqlParameter("@ConsortiaID", player.ConsortiaID);
                para[4] = new SqlParameter("@Defence", player.Defence);
                para[5] = new SqlParameter("@Gold", player.Gold);
                para[6] = new SqlParameter("@GP", player.GP);
                para[7] = new SqlParameter("@Grade", player.Grade);
                para[8] = new SqlParameter("@Luck", player.Luck);
                para[9] = new SqlParameter("@Money", player.Money);
                para[10] = new SqlParameter("@Style", (player.Style == null) ? "" : player.Style);
                para[11] = new SqlParameter("@Agility", player.Agility);
                para[12] = new SqlParameter("@State", player.State);
                para[13] = new SqlParameter("@Hide", player.Hide);
                para[14] = new SqlParameter("@ExpendDate", (!player.ExpendDate.HasValue) ? "" : player.ExpendDate.ToString());
                para[15] = new SqlParameter("@Win", player.Win);
                para[16] = new SqlParameter("@Total", player.Total);
                para[17] = new SqlParameter("@Escape", player.Escape);
                para[18] = new SqlParameter("@Skin", (player.Skin == null) ? "" : player.Skin);
                para[19] = new SqlParameter("@Offer", player.Offer);
                para[20] = new SqlParameter("@AntiAddiction", player.AntiAddiction);
                para[20].Direction = ParameterDirection.InputOutput;
                para[21] = new SqlParameter("@Result", SqlDbType.Int);
                para[21].Direction = ParameterDirection.ReturnValue;
                para[22] = new SqlParameter("@RichesOffer", player.RichesOffer);
                para[23] = new SqlParameter("@RichesRob", player.RichesRob);
                para[24] = new SqlParameter("@CheckCount", player.CheckCount);
                para[24].Direction = ParameterDirection.InputOutput;
                para[25] = new SqlParameter("@MarryInfoID", player.MarryInfoID);
                para[26] = new SqlParameter("@DayLoginCount", player.DayLoginCount);
                para[27] = new SqlParameter("@Nimbus", player.Nimbus);
                para[28] = new SqlParameter("@LastAward", player.LastAward);
                para[29] = new SqlParameter("@GiftToken", player.GiftToken);
                para[30] = new SqlParameter("@QuestSite", player.QuestSite);
                para[31] = new SqlParameter("@PvePermission", player.PvePermission);
                para[32] = new SqlParameter("@FightPower", player.FightPower);
                para[33] = new SqlParameter("@AnswerSite", player.AnswerSite);
                para[34] = new SqlParameter("@LastAuncherAward", player.LastAward);
                para[35] = new SqlParameter("@hp", player.hp);
                para[36] = new SqlParameter("@ChatCount", player.ChatCount);
                para[37] = new SqlParameter("@SpaPubGoldRoomLimit", player.SpaPubGoldRoomLimit);
                para[38] = new SqlParameter("@LastSpaDate", player.LastSpaDate);
                para[39] = new SqlParameter("@FightLabPermission", player.FightLabPermission);
                para[40] = new SqlParameter("@SpaPubMoneyRoomLimit", player.SpaPubMoneyRoomLimit);
                para[41] = new SqlParameter("@IsInSpaPubGoldToday", player.IsInSpaPubGoldToday);
                para[42] = new SqlParameter("@IsInSpaPubMoneyToday", player.IsInSpaPubMoneyToday);
                para[43] = new SqlParameter("@AchievementPoint", player.AchievementPoint);
                para[44] = new SqlParameter("@LastWeekly", player.LastWeekly);
                para[45] = new SqlParameter("@LastWeeklyVersion", player.LastWeeklyVersion);
                para[46] = new SqlParameter("@WeaklessGuildProgressStr", player.WeaklessGuildProgressStr);
                para[47] = new SqlParameter("@IsOldPlayer", player.IsOldPlayer);
                para[48] = new SqlParameter("@VIPLevel", player.VIPLevel);
                para[49] = new SqlParameter("@VIPExp", player.VIPExp);
                para[50] = new SqlParameter("@Score", player.Score);
                para[51] = new SqlParameter("@OptionOnOff", player.OptionOnOff);
                para[52] = new SqlParameter("@isOldPlayerHasValidEquitAtLogin", player.isOldPlayerHasValidEquitAtLogin);
                para[53] = new SqlParameter("@badLuckNumber", player.badLuckNumber);
                para[54] = new SqlParameter("@luckyNum", player.luckyNum);
                para[55] = new SqlParameter("@lastLuckyNumDate", player.lastLuckyNumDate);
                para[56] = new SqlParameter("@lastLuckNum", player.lastLuckNum);
                para[57] = new SqlParameter("@IsShowConsortia", player.IsShowConsortia);
                para[58] = new SqlParameter("@NewDay", player.NewDay);
                para[59] = new SqlParameter("@Medal", player.medal);
                para[60] = new SqlParameter("@Honor", player.Honor);
                para[61] = new SqlParameter("@VIPNextLevelDaysNeeded", player.GetVIPNextLevelDaysNeeded(player.VIPLevel, player.VIPExp));
                para[62] = new SqlParameter("@IsRecharged", player.IsRecharged);
                para[63] = new SqlParameter("@IsGetAward", player.IsGetAward);
                para[64] = new SqlParameter("@typeVIP", player.typeVIP);
                para[65] = new SqlParameter("@evolutionGrade", player.evolutionGrade);
                para[66] = new SqlParameter("@evolutionExp", player.evolutionExp);
                para[67] = new SqlParameter("@hardCurrency", player.hardCurrency);
                para[68] = new SqlParameter("@EliteScore", player.EliteScore);
                para[69] = new SqlParameter("@UseOffer", player.UseOffer);
                para[70] = new SqlParameter("@ShopFinallyGottenTime", player.ShopFinallyGottenTime);
                para[71] = new SqlParameter("@MoneyLock", player.MoneyLock);
                para[72] = new SqlParameter("@LastGetEgg", player.LastGetEgg);
                para[73] = new SqlParameter("@IsFistGetPet", player.IsFistGetPet);
                para[74] = new SqlParameter("@LastRefreshPet", player.LastRefreshPet);
                para[75] = new SqlParameter("@petScore", player.petScore);
                para[76] = new SqlParameter("@accumulativeLoginDays", player.accumulativeLoginDays);
                para[77] = new SqlParameter("@accumulativeAwardDays", player.accumulativeAwardDays);
                para[78] = new SqlParameter("@honorId", player.honorId);
                para[79] = new SqlParameter("@Repute", player.Repute);
                para[80] = new SqlParameter("@damageScores", player.damageScores);
                para[81] = new SqlParameter("@totemId", player.totemId);
                para[82] = new SqlParameter("@myHonor", player.myHonor);
                para[83] = new SqlParameter("@MaxBuyHonor", player.MaxBuyHonor);
                para[84] = new SqlParameter("@necklaceExp", player.necklaceExp);
                para[85] = new SqlParameter("@necklaceExpAdd", player.necklaceExpAdd);
                sqlParameters2 = para;
                db.RunProcedure("SP_Users_Update", para);
                flag = (int)para[21].Value == 0;
                if (flag)
                {
                    player.AntiAddiction = (int)para[20].Value;
                    player.CheckCount = (int)para[24].Value;
                }
                player.IsDirty = false;
                return flag;
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    foreach (SqlParameter item in sqlParameters2)
                    {
                        log.Info(string.Concat("Error ", item.ParameterName, "=", item.Value));
                    }

                    log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePlayerGotRingProp(int groomID, int brideID)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@GroomID", groomID),
                    new SqlParameter("@BrideID", brideID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Update_GotRing_Prop", sqlParameters);
                flag = (int)sqlParameters[2].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdatePlayerGotRingProp", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePlayerLastAward(int id, int type)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", id),
                    new SqlParameter("@Type", type)
                };
                flag = db.RunProcedure("SP_Users_LastAward", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdatePlayerAward", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePlayerMarry(PlayerInfo player)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[7]
                {
                    new SqlParameter("@UserID", player.ID),
                    new SqlParameter("@IsMarried", player.IsMarried),
                    new SqlParameter("@SpouseID", player.SpouseID),
                    new SqlParameter("@SpouseName", player.SpouseName),
                    new SqlParameter("@IsCreatedMarryRoom", player.IsCreatedMarryRoom),
                    new SqlParameter("@SelfMarryRoomID", player.SelfMarryRoomID),
                    new SqlParameter("@IsGotRing", player.IsGotRing)
                };
                flag = db.RunProcedure("SP_Users_Marry", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdatePlayerMarry", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdatePlayerMarryApply(int UserID, string loveProclamation, bool isExist)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[4]
                {
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@LoveProclamation", loveProclamation),
                    new SqlParameter("@isExist", isExist),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[3].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Update_Marry_Apply", sqlParameters);
                flag = (int)sqlParameters[3].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdatePlayerMarryApply", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateUserMatchInfo(UserMatchInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] para = new SqlParameter[17];
                para[0] = new SqlParameter("@ID", info.ID);
                para[1] = new SqlParameter("@UserID", info.UserID);
                para[2] = new SqlParameter("@dailyScore", info.dailyScore);
                para[3] = new SqlParameter("@dailyWinCount", info.dailyWinCount);
                para[4] = new SqlParameter("@dailyGameCount", info.dailyGameCount);
                para[5] = new SqlParameter("@DailyLeagueFirst", info.DailyLeagueFirst);
                para[6] = new SqlParameter("@DailyLeagueLastScore", info.DailyLeagueLastScore);
                para[7] = new SqlParameter("@weeklyScore", info.weeklyScore);
                para[8] = new SqlParameter("@weeklyGameCount", info.weeklyGameCount);
                para[9] = new SqlParameter("@weeklyRanking", info.weeklyRanking);
                para[10] = new SqlParameter("@addDayPrestge", info.addDayPrestge);
                para[11] = new SqlParameter("@totalPrestige", info.totalPrestige);
                para[12] = new SqlParameter("@restCount", info.restCount);
                para[13] = new SqlParameter("@leagueGrade", info.leagueGrade);
                para[14] = new SqlParameter("@leagueItemsGet", info.leagueItemsGet);
                para[15] = new SqlParameter("@WeeklyWinCount", info.WeeklyWinCount);
                para[16] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[16].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateUserMatch", para);
                flag = (int)para[16].Value == 0;
            }
            catch (Exception exception)
            {
                if (log.IsErrorEnabled)
                {
                    log.Error("SP_UpdateUserMatch", exception);
                }
            }
            return flag;
        }

        public bool UpdateUserRank(UserRankInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[16]
                {
                    new SqlParameter("@ID", item.ID),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@UserRank", item.Name),
                    new SqlParameter("@Attack", item.Attack),
                    new SqlParameter("@Defence", item.Defence),
                    new SqlParameter("@Luck", item.Luck),
                    new SqlParameter("@Agility", item.Agility),
                    new SqlParameter("@HP", item.HP),
                    new SqlParameter("@Damage", item.Damage),
                    new SqlParameter("@Guard", item.Guard),
                    new SqlParameter("@BeginDate", item.BeginDate),
                    new SqlParameter("@Validate", item.Validate),
                    new SqlParameter("@IsExit", item.IsExit),
                    new SqlParameter("@Result", SqlDbType.Int),
                    null,
                    null
                };
                para[13].Direction = ParameterDirection.ReturnValue;
                para[14] = new SqlParameter("@NewTitleID", item.NewTitleID);
                para[15] = new SqlParameter("@EndDate", item.EndDate);
                db.RunProcedure("SP_UpdateUserRank", para);
                result = (int)para[13].Value == 0;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateUserRank", exception);
                }
            }
            return result;
        }

        public bool UpdateUserExtra(UsersExtraInfo ex)
        {
            bool flag = false;
            try
            {
                flag = db.RunProcedure("SP_Update_User_Extra", new SqlParameter[12]
                {
                    new SqlParameter("@UserID", ex.UserID),
                    new SqlParameter("@LastTimeHotSpring", ex.LastTimeHotSpring),
                    new SqlParameter("@MinHotSpring", ex.MinHotSpring),
                    new SqlParameter("@coupleBossEnterNum", ex.coupleBossEnterNum),
                    new SqlParameter("@coupleBossHurt", ex.coupleBossHurt),
                    new SqlParameter("@coupleBossBoxNum", ex.coupleBossBoxNum),
                    new SqlParameter("@LastFreeTimeHotSpring", ex.LastFreeTimeHotSpring),
                    new SqlParameter("@isGetAwardMarry", ex.isGetAwardMarry),
                    new SqlParameter("@isFirstAwardMarry", ex.isFirstAwardMarry),
                    new SqlParameter("@LeftRoutteCount", ex.LeftRoutteCount),
                    new SqlParameter("@LeftRoutteRate", ex.LeftRoutteRate),
                    new SqlParameter("@FreeSendMailCount", ex.FreeSendMailCount)
                });
                return flag;
            }
            catch (Exception ex2)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex2);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateUserTexpInfo(TexpInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[10]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@attTexpExp", info.attTexpExp),
                    new SqlParameter("@defTexpExp", info.defTexpExp),
                    new SqlParameter("@hpTexpExp", info.hpTexpExp),
                    new SqlParameter("@lukTexpExp", info.lukTexpExp),
                    new SqlParameter("@spdTexpExp", info.spdTexpExp),
                    new SqlParameter("@texpCount", info.texpCount),
                    new SqlParameter("@texpTaskCount", info.texpTaskCount),
                    new SqlParameter("@texpTaskDate", info.texpTaskDate),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[9].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UserTexp_Update", sqlParameters);
                flag = (int)sqlParameters[9].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateVIPInfo(PlayerInfo p)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[10]
                {
                    new SqlParameter("@ID", p.ID),
                    new SqlParameter("@VIPLevel", p.VIPLevel),
                    new SqlParameter("@VIPExp", p.VIPExp),
                    new SqlParameter("@VIPOnlineDays", SqlDbType.BigInt),
                    new SqlParameter("@VIPOfflineDays", SqlDbType.BigInt),
                    new SqlParameter("@VIPExpireDay", p.VIPExpireDay),
                    new SqlParameter("@VIPLastDate", DateTime.Now),
                    new SqlParameter("@VIPNextLevelDaysNeeded", p.GetVIPNextLevelDaysNeeded(p.VIPLevel, p.VIPExp)),
                    new SqlParameter("@CanTakeVipReward", p.CanTakeVipReward),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[9].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateVIPInfo", sqlParameters);
                flag = true;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateVIPInfo", exception);
                    return flag;
                }
                return flag;
            }
        }

        public int VIPLastdate(int ID)
        {
            int num = 0;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_VIPLastdate_Single", sqlParameters);
                num = (int)sqlParameters[1].Value;
                return num;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_VIPLastdate_Single", exception);
                    return num;
                }
                return num;
            }
        }

        public int VIPRenewal(string nickName, int renewalDays, int typeVIP, ref DateTime ExpireDayOut)
        {
            int num = 0;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[5]
                {
                    new SqlParameter("@NickName", nickName),
                    new SqlParameter("@RenewalDays", renewalDays),
                    new SqlParameter("@ExpireDayOut", DateTime.Now),
                    new SqlParameter("@typeVIP", typeVIP),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[2].Direction = ParameterDirection.Output;
                sqlParameters[4].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_VIPRenewal_Single", sqlParameters);
                ExpireDayOut = (DateTime)sqlParameters[2].Value;
                num = (int)sqlParameters[4].Value;
                return num;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_VIPRenewal_Single", exception);
                    return num;
                }
                return num;
            }
        }

        public bool UpdateAcademyPlayer(PlayerInfo player)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[8]
                {
                    new SqlParameter("@UserID", player.ID),
                    new SqlParameter("@apprenticeshipState", player.apprenticeshipState),
                    new SqlParameter("@masterID", player.masterID),
                    new SqlParameter("@masterOrApprentices", player.masterOrApprentices),
                    new SqlParameter("@graduatesCount", player.graduatesCount),
                    new SqlParameter("@honourOfMaster", player.honourOfMaster),
                    null,
                    new SqlParameter("@freezesDate", player.freezesDate)
                };
                SqlParameters[6] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[6].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UsersAcademy_Update", SqlParameters);
                flag = (int)SqlParameters[6].Value == 0;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdateAcademyPlayer", ex);
                    return flag;
                }
                return flag;
            }
        }

        public void AddDailyRecord(DailyRecordInfo info)
        {
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@Type", info.Type),
                    new SqlParameter("@Value", info.Value)
                };
                db.RunProcedure("SP_DailyRecordInfo_Add", sqlParameters);
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("AddDailyRecord", exception);
                }
            }
        }

        public bool DeleteDailyRecord(int UserID, int Type)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@Type", Type)
                };
                flag = db.RunProcedure("SP_DailyRecordInfo_Delete", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_DailyRecordInfo_Delete", exception);
                    return flag;
                }
                return flag;
            }
        }

        public DailyRecordInfo[] GetDailyRecord(int UserID)
        {
            List<DailyRecordInfo> list = new List<DailyRecordInfo>();
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", UserID)
                };
                db.GetReader(ref resultDataReader, "SP_DailyRecordInfo_Single", sqlParameters);
                while (resultDataReader.Read())
                {
                    DailyRecordInfo item = new DailyRecordInfo
                    {
                        UserID = (int)resultDataReader["UserID"],
                        Type = (int)resultDataReader["Type"],
                        Value = (string)resultDataReader["Value"]
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetDailyRecord", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public string GetASSInfoSingle(int UserID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", UserID)
                };
                db.GetReader(ref resultDataReader, "SP_ASSInfo_Single", sqlParameters);
                if (resultDataReader.Read())
                {
                    return resultDataReader["IDNumber"].ToString();
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetASSInfoSingle", exception);
                }
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return "";
        }

        public DailyLogListInfo GetDailyLogListSingle(int UserID)
        {
            SqlDataReader resultDataReader = null;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", UserID)
                };
                db.GetReader(ref resultDataReader, "SP_DailyLogList_Single", sqlParameters);
                if (resultDataReader.Read())
                {
                    return new DailyLogListInfo
                    {
                        ID = (int)resultDataReader["ID"],
                        UserID = (int)resultDataReader["UserID"],
                        UserAwardLog = (int)resultDataReader["UserAwardLog"],
                        DayLog = (string)resultDataReader["DayLog"],
                        LastDate = (DateTime)resultDataReader["LastDate"]
                    };
                }
            }
            catch (Exception exception)
            {
                BaseBussiness.log.Error("DailyLogList", exception);
            }
            finally
            {
                if (resultDataReader != null && !resultDataReader.IsClosed)
                {
                    resultDataReader.Close();
                }
            }
            return null;
        }

        public bool UpdateDailyLogList(DailyLogListInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[5]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@UserAwardLog", info.UserAwardLog),
                    new SqlParameter("@DayLog", info.DayLog),
                    new SqlParameter("@LastDate", info.LastDate),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[4].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_DailyLogList_Update", sqlParameters);
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_DailyLogList_Update", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateBoxProgression(int userid, int boxProgression, int getBoxLevel, DateTime addGPLastDate, DateTime BoxGetDate, int alreadyBox)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[6]
                {
                    new SqlParameter("@UserID", userid),
                    new SqlParameter("@BoxProgression", boxProgression),
                    new SqlParameter("@GetBoxLevel", getBoxLevel),
                    new SqlParameter("@AddGPLastDate", DateTime.Now),
                    new SqlParameter("@BoxGetDate", BoxGetDate),
                    new SqlParameter("@AlreadyGetBox", alreadyBox)
                };
                result = db.RunProcedure("SP_User_Update_BoxProgression", para);
                return result;
            }
            catch (Exception e)
            {
                BaseBussiness.log.Error("User_Update_BoxProgression", e);
                return result;
            }
        }

        public bool UpdatePlayerInfoHistory(PlayerInfoHistory info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[4]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@LastQuestsTime", info.LastQuestsTime),
                    new SqlParameter("@LastTreasureTime", info.LastTreasureTime),
                    new SqlParameter("@OutPut", SqlDbType.Int)
                };
                sqlParameters[3].Direction = ParameterDirection.Output;
                db.RunProcedure("SP_User_Update_History", sqlParameters);
                flag = (int)sqlParameters[6].Value == 1;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("User_Update_BoxProgression", exception);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddAASInfo(AASInfo info)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[5]
                {
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@Name", info.Name),
                    new SqlParameter("@IDNumber", info.IDNumber),
                    new SqlParameter("@State", info.State),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameters[4].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_ASSInfo_Add", sqlParameters);
                flag = (int)sqlParameters[4].Value == 0;
                return flag;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("UpdateAASInfo", exception);
                    return flag;
                }
                return flag;
            }
        }

        public void AddUserLogEvent(int UserID, string UserName, string NickName, string Type, string Content)
        {
            try
            {
                SqlParameter[] sqlParameters = new SqlParameter[5]
                {
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@UserName", UserName),
                    new SqlParameter("@NickName", NickName),
                    new SqlParameter("@Type", Type),
                    new SqlParameter("@Content", Content)
                };
                db.RunProcedure("SP_Insert_UsersLog", sqlParameters);
            }
            catch (Exception)
            {
            }
        }

        public Dictionary<int, List<string>> LoadCommands()
        {
            SqlDataReader sqlDataReader = null;
            Dictionary<int, List<string>> commands = new Dictionary<int, List<string>>();
            db.GetReader(ref sqlDataReader, "SP_GetAllCommands");
            while (sqlDataReader.Read())
            {
                string[] array = Convert.ToString(sqlDataReader["Commands"] ?? "").Split('$');
                List<string> c = new List<string>();
                string[] array2 = array;
                string[] array3 = array2;
                foreach (string s in array3)
                {
                    c.Add(s);
                }
                if (!commands.ContainsKey(Convert.ToInt32(sqlDataReader["UserID"] ?? ((object)0))))
                {
                    commands.Add(Convert.ToInt32(sqlDataReader["UserID"] ?? ((object)0)), c);
                }
            }
            return commands;
        }

        public bool AddUserAdoptPet(UsersPetInfo info, bool isUse)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[23]
                {
                    new SqlParameter("@TemplateID", info.TemplateID),
                    new SqlParameter("@Name", (info.Name == null) ? "Error!" : info.Name),
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@Attack", info.Attack),
                    new SqlParameter("@Defence", info.Defence),
                    new SqlParameter("@Luck", info.Luck),
                    new SqlParameter("@Agility", info.Agility),
                    new SqlParameter("@Blood", info.Blood),
                    new SqlParameter("@Damage", info.Damage),
                    new SqlParameter("@Guard", info.Guard),
                    new SqlParameter("@AttackGrow", info.AttackGrow),
                    new SqlParameter("@DefenceGrow", info.DefenceGrow),
                    new SqlParameter("@LuckGrow", info.LuckGrow),
                    new SqlParameter("@AgilityGrow", info.AgilityGrow),
                    new SqlParameter("@BloodGrow", info.BloodGrow),
                    new SqlParameter("@DamageGrow", info.DamageGrow),
                    new SqlParameter("@GuardGrow", info.GuardGrow),
                    new SqlParameter("@Skill", info.Skill),
                    new SqlParameter("@SkillEquip", info.SkillEquip),
                    new SqlParameter("@Place", info.Place),
                    new SqlParameter("@IsExit", info.IsExit),
                    new SqlParameter("@IsUse", isUse),
                    new SqlParameter("@ID", info.ID)
                };
                para[22].Direction = ParameterDirection.Output;
                result = db.RunProcedure("SP_User_AdoptPet", para);
                info.ID = (int)para[22].Value;
                info.IsDirty = false;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            return result;
        }

        public bool RemoveUserAdoptPet(int ID)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[2]
                {
                    new SqlParameter("@ID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                para[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Remove_User_AdoptPet", para);
                int returnValue = (int)para[1].Value;
                result = returnValue == 0;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            return result;
        }

        public bool UpdateUserAdoptPet(int ID)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[2]
                {
                    new SqlParameter("@ID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                para[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Update_User_AdoptPet", para);
                int returnValue = (int)para[1].Value;
                result = returnValue == 0;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            return result;
        }

        public bool ClearAdoptPet(int ID)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[2]
                {
                    new SqlParameter("@ID", ID),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                para[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Clear_AdoptPet", para);
                int returnValue = (int)para[1].Value;
                result = returnValue == 0;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            return result;
        }

        public UsersPetInfo[] GetUserPetSingles(int UserID, int vipLv)
        {
            List<UsersPetInfo> items = new List<UsersPetInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = UserID;
                db.GetReader(ref reader, "SP_Get_UserPet_By_ID", para);
                while (reader.Read())
                {
                    UsersPetInfo info = InitPet(reader);
                    info.VIPLevel = vipLv;
                    items.Add(info);
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return items.ToArray();
        }

        public bool UpdateUserPet(UsersPetInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[39]
                {
                    new SqlParameter("@TemplateID", item.TemplateID),
                    new SqlParameter("@Name", (item.Name == null) ? "Error!" : item.Name),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@Attack", item.Attack),
                    new SqlParameter("@Defence", item.Defence),
                    new SqlParameter("@Luck", item.Luck),
                    new SqlParameter("@Agility", item.Agility),
                    new SqlParameter("@Blood", item.Blood),
                    new SqlParameter("@Damage", item.Damage),
                    new SqlParameter("@Guard", item.Guard),
                    new SqlParameter("@AttackGrow", item.AttackGrow),
                    new SqlParameter("@DefenceGrow", item.DefenceGrow),
                    new SqlParameter("@LuckGrow", item.LuckGrow),
                    new SqlParameter("@AgilityGrow", item.AgilityGrow),
                    new SqlParameter("@BloodGrow", item.BloodGrow),
                    new SqlParameter("@DamageGrow", item.DamageGrow),
                    new SqlParameter("@GuardGrow", item.GuardGrow),
                    new SqlParameter("@Level", item.Level),
                    new SqlParameter("@GP", item.GP),
                    new SqlParameter("@MaxGP", item.MaxGP),
                    new SqlParameter("@Hunger", item.Hunger),
                    new SqlParameter("@PetHappyStar", item.PetHappyStar),
                    new SqlParameter("@MP", item.MP),
                    new SqlParameter("@IsEquip", item.IsEquip),
                    new SqlParameter("@Place", item.Place),
                    new SqlParameter("@IsExit", item.IsExit),
                    new SqlParameter("@ID", item.ID),
                    new SqlParameter("@Skill", item.Skill),
                    new SqlParameter("@SkillEquip", item.SkillEquip),
                    new SqlParameter("@currentStarExp", item.currentStarExp),
                    new SqlParameter("@Result", SqlDbType.Int),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                SqlParameters[30].Direction = ParameterDirection.ReturnValue;
                SqlParameters[31] = new SqlParameter("@breakGrade", item.breakGrade);
                SqlParameters[32] = new SqlParameter("@breakAttack", item.breakAttack);
                SqlParameters[33] = new SqlParameter("@breakDefence", item.breakDefence);
                SqlParameters[34] = new SqlParameter("@breakAgility", item.breakAgility);
                SqlParameters[35] = new SqlParameter("@breakLuck", item.breakLuck);
                SqlParameters[36] = new SqlParameter("@breakBlood", item.breakBlood);
                SqlParameters[37] = new SqlParameter("@eQPets", item.eQPets);
                SqlParameters[38] = new SqlParameter("@BaseProp", item.BaseProp);
                db.RunProcedure("SP_UserPet_Update", SqlParameters);
                flag = (int)SqlParameters[30].Value == 0;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool AddUserPet(UsersPetInfo item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[39]
                {
                    new SqlParameter("@TemplateID", item.TemplateID),
                    new SqlParameter("@Name", (item.Name == null) ? "Error!" : item.Name),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@Attack", item.Attack),
                    new SqlParameter("@Defence", item.Defence),
                    new SqlParameter("@Luck", item.Luck),
                    new SqlParameter("@Agility", item.Agility),
                    new SqlParameter("@Blood", item.Blood),
                    new SqlParameter("@Damage", item.Damage),
                    new SqlParameter("@Guard", item.Guard),
                    new SqlParameter("@AttackGrow", item.AttackGrow),
                    new SqlParameter("@DefenceGrow", item.DefenceGrow),
                    new SqlParameter("@LuckGrow", item.LuckGrow),
                    new SqlParameter("@AgilityGrow", item.AgilityGrow),
                    new SqlParameter("@BloodGrow", item.BloodGrow),
                    new SqlParameter("@DamageGrow", item.DamageGrow),
                    new SqlParameter("@GuardGrow", item.GuardGrow),
                    new SqlParameter("@Level", item.Level),
                    new SqlParameter("@GP", item.GP),
                    new SqlParameter("@MaxGP", item.MaxGP),
                    new SqlParameter("@Hunger", item.Hunger),
                    new SqlParameter("@PetHappyStar", item.PetHappyStar),
                    new SqlParameter("@MP", item.MP),
                    new SqlParameter("@IsEquip", item.IsEquip),
                    new SqlParameter("@Skill", item.Skill),
                    new SqlParameter("@SkillEquip", item.SkillEquip),
                    new SqlParameter("@Place", item.Place),
                    new SqlParameter("@IsExit", item.IsExit),
                    new SqlParameter("@ID", item.ID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                SqlParameters[28].Direction = ParameterDirection.Output;
                SqlParameters[29] = new SqlParameter("@currentStarExp", item.currentStarExp);
                SqlParameters[30] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[30].Direction = ParameterDirection.ReturnValue;
                SqlParameters[31] = new SqlParameter("@breakGrade", item.breakGrade);
                SqlParameters[32] = new SqlParameter("@breakAttack", item.breakAttack);
                SqlParameters[33] = new SqlParameter("@breakDefence", item.breakDefence);
                SqlParameters[34] = new SqlParameter("@breakAgility", item.breakAgility);
                SqlParameters[35] = new SqlParameter("@breakLuck", item.breakLuck);
                SqlParameters[36] = new SqlParameter("@breakBlood", item.breakBlood);
                SqlParameters[37] = new SqlParameter("@eQPets", item.eQPets);
                SqlParameters[38] = new SqlParameter("@BaseProp", item.BaseProp);
                flag = db.RunProcedure("SP_User_Add_Pet", SqlParameters);
                flag = (int)SqlParameters[30].Value == 0;
                item.ID = (int)SqlParameters[28].Value;
                item.IsDirty = false;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public UsersPetInfo InitPet(SqlDataReader reader)
        {
            return new UsersPetInfo
            {
                ID = (int)reader["ID"],
                TemplateID = (int)reader["TemplateID"],
                Name = reader["Name"].ToString(),
                UserID = (int)reader["UserID"],
                Attack = (int)reader["Attack"],
                AttackGrow = (int)reader["AttackGrow"],
                Agility = (int)reader["Agility"],
                AgilityGrow = (int)reader["AgilityGrow"],
                Defence = (int)reader["Defence"],
                DefenceGrow = (int)reader["DefenceGrow"],
                Luck = (int)reader["Luck"],
                LuckGrow = (int)reader["LuckGrow"],
                Blood = (int)reader["Blood"],
                BloodGrow = (int)reader["BloodGrow"],
                Damage = (int)reader["Damage"],
                DamageGrow = (int)reader["DamageGrow"],
                Guard = (int)reader["Guard"],
                GuardGrow = (int)reader["GuardGrow"],
                Level = (int)reader["Level"],
                GP = (int)reader["GP"],
                MaxGP = (int)reader["MaxGP"],
                Hunger = (int)reader["Hunger"],
                MP = (int)reader["MP"],
                Place = (int)reader["Place"],
                IsEquip = (bool)reader["IsEquip"],
                IsExit = (bool)reader["IsExit"],
                Skill = reader["Skill"].ToString(),
                SkillEquip = reader["SkillEquip"].ToString(),
                currentStarExp = (int)reader["currentStarExp"],
                breakGrade = (int)reader["breakGrade"],
                breakAttack = (int)reader["breakAttack"],
                breakDefence = (int)reader["breakDefence"],
                breakAgility = (int)reader["breakAgility"],
                breakLuck = (int)reader["breakLuck"],
                breakBlood = (int)reader["breakBlood"],
                eQPets = ((reader["eQPets"] == null) ? "" : reader["eQPets"].ToString()),
                BaseProp = ((reader["BaseProp"] == null) ? "" : reader["BaseProp"].ToString())
            };
        }

        public bool RegisterPlayer2(string userName, string passWord, string nickName, int attack, int defence, int agility, int luck, int cateogryId, string bStyle, string bPic, string gStyle, string armColor, string hairColor, string faceColor, string clothColor, string hatchColor, int sex, ref string msg, int validDate)
        {
            bool flag = false;
            try
            {
                string[] strArray1 = bStyle.Split(',');
                string[] strArray2 = gStyle.Split(',');
                string[] strArray3 = bPic.Split(',');
                SqlParameter[] SqlParameters = new SqlParameter[31];
                SqlParameters[0] = new SqlParameter("@UserName", userName);
                SqlParameters[1] = new SqlParameter("@PassWord", passWord);
                SqlParameters[2] = new SqlParameter("@NickName", nickName);
                SqlParameters[3] = new SqlParameter("@BArmID", int.Parse(strArray1[0]));
                SqlParameters[4] = new SqlParameter("@BHairID", int.Parse(strArray1[1]));
                SqlParameters[5] = new SqlParameter("@BFaceID", int.Parse(strArray1[2]));
                SqlParameters[6] = new SqlParameter("@BClothID", int.Parse(strArray1[3]));
                SqlParameters[7] = new SqlParameter("@BHatID", int.Parse(strArray1[4]));
                SqlParameters[21] = new SqlParameter("@ArmPic", strArray3[0]);
                SqlParameters[22] = new SqlParameter("@HairPic", strArray3[1]);
                SqlParameters[23] = new SqlParameter("@FacePic", strArray3[2]);
                SqlParameters[24] = new SqlParameter("@ClothPic", strArray3[3]);
                SqlParameters[25] = new SqlParameter("@HatPic", strArray3[4]);
                SqlParameters[8] = new SqlParameter("@GArmID", int.Parse(strArray2[0]));
                SqlParameters[9] = new SqlParameter("@GHairID", int.Parse(strArray2[1]));
                SqlParameters[10] = new SqlParameter("@GFaceID", int.Parse(strArray2[2]));
                SqlParameters[11] = new SqlParameter("@GClothID", int.Parse(strArray2[3]));
                SqlParameters[12] = new SqlParameter("@GHatID", int.Parse(strArray2[4]));
                SqlParameters[13] = new SqlParameter("@ArmColor", armColor);
                SqlParameters[14] = new SqlParameter("@HairColor", hairColor);
                SqlParameters[15] = new SqlParameter("@FaceColor", faceColor);
                SqlParameters[16] = new SqlParameter("@ClothColor", clothColor);
                SqlParameters[17] = new SqlParameter("@HatColor", clothColor);
                SqlParameters[18] = new SqlParameter("@Sex", sex);
                SqlParameters[19] = new SqlParameter("@StyleDate", validDate);
                SqlParameters[26] = new SqlParameter("@CategoryID", cateogryId);
                SqlParameters[27] = new SqlParameter("@Attack", attack);
                SqlParameters[28] = new SqlParameter("@Defence", defence);
                SqlParameters[29] = new SqlParameter("@Agility", agility);
                SqlParameters[30] = new SqlParameter("@Luck", luck);
                SqlParameters[20] = new SqlParameter("@Result", SqlDbType.Int);
                SqlParameters[20].Direction = ParameterDirection.ReturnValue;
                flag = db.RunProcedure("SP_Users_RegisterNotValidate2", SqlParameters);
                int num = (int)SqlParameters[20].Value;
                flag = num == 0;
                switch (num)
                {
                    case 2:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.RegisterPlayer.Msg2");
                        return flag;
                    case 3:
                        msg = LanguageMgr.GetTranslation("PlayerBussiness.RegisterPlayer.Msg3");
                        return flag;
                    default:
                        return flag;
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error($"{userName} {passWord} {nickName} {attack} {defence} {agility} {luck} {cateogryId} {bStyle} {bPic} {gStyle}");
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateUserReputeFightPower()
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[0].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Update_Repute_FightPower", SqlParameters);
                flag = (int)SqlParameters[0].Value == 0;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public UsersExtraInfo[] GetRankCaddy()
        {
            List<UsersExtraInfo> userExtraInfoList = new List<UsersExtraInfo>();
            SqlDataReader ResultDataReader = null;
            try
            {
                db.GetReader(ref ResultDataReader, "SP_Get_Rank_Caddy");
                while (ResultDataReader.Read())
                {
                    userExtraInfoList.Add(new UsersExtraInfo
                    {
                        UserID = (int)ResultDataReader["UserID"],
                        NickName = (string)ResultDataReader["NickName"],
                        TotalCaddyOpen = (int)ResultDataReader["badLuckNumber"]
                    });
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_Get_Rank_Caddy", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return userExtraInfoList.ToArray();
        }

        public UserLabyrinthInfo GetSingleLabyrinth(int ID)
        {
            SqlDataReader ResultDataReader = null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[1]
                {
                    new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                SqlParameters[0].Value = ID;
                db.GetReader(ref ResultDataReader, "SP_GetSingleLabyrinth", SqlParameters);
                if (ResultDataReader.Read())
                {
                    return new UserLabyrinthInfo
                    {
                        UserID = (int)ResultDataReader["UserID"],
                        myProgress = (int)ResultDataReader["myProgress"],
                        myRanking = (int)ResultDataReader["myRanking"],
                        completeChallenge = (bool)ResultDataReader["completeChallenge"],
                        isDoubleAward = (bool)ResultDataReader["isDoubleAward"],
                        currentFloor = (int)ResultDataReader["currentFloor"],
                        accumulateExp = (int)ResultDataReader["accumulateExp"],
                        remainTime = (int)ResultDataReader["remainTime"],
                        currentRemainTime = (int)ResultDataReader["currentRemainTime"],
                        cleanOutAllTime = (int)ResultDataReader["cleanOutAllTime"],
                        cleanOutGold = (int)ResultDataReader["cleanOutGold"],
                        tryAgainComplete = (bool)ResultDataReader["tryAgainComplete"],
                        isInGame = (bool)ResultDataReader["isInGame"],
                        isCleanOut = (bool)ResultDataReader["isCleanOut"],
                        serverMultiplyingPower = (bool)ResultDataReader["serverMultiplyingPower"],
                        LastDate = (DateTime)ResultDataReader["LastDate"],
                        ProcessAward = (string)ResultDataReader["ProcessAward"]
                    };
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_GetSingleUserLabyrinth", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return null;
        }

        public bool AddUserLabyrinth(UserLabyrinthInfo laby)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[18]
                {
                    new SqlParameter("@UserID", laby.UserID),
                    new SqlParameter("@myProgress", laby.myProgress),
                    new SqlParameter("@myRanking", laby.myRanking),
                    new SqlParameter("@completeChallenge", laby.completeChallenge),
                    new SqlParameter("@isDoubleAward", laby.isDoubleAward),
                    new SqlParameter("@currentFloor", laby.currentFloor),
                    new SqlParameter("@accumulateExp", laby.accumulateExp),
                    new SqlParameter("@remainTime", laby.remainTime),
                    new SqlParameter("@currentRemainTime", laby.currentRemainTime),
                    new SqlParameter("@cleanOutAllTime", laby.cleanOutAllTime),
                    new SqlParameter("@cleanOutGold", laby.cleanOutGold),
                    new SqlParameter("@tryAgainComplete", laby.tryAgainComplete),
                    new SqlParameter("@isInGame", laby.isInGame),
                    new SqlParameter("@isCleanOut", laby.isCleanOut),
                    new SqlParameter("@serverMultiplyingPower", laby.serverMultiplyingPower),
                    new SqlParameter("@LastDate", laby.LastDate),
                    new SqlParameter("@ProcessAward", laby.ProcessAward),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[17].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Users_Labyrinth_Add", SqlParameters);
                flag = (int)SqlParameters[17].Value == 0;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateLabyrinthInfo(UserLabyrinthInfo laby)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[18]
                {
                    new SqlParameter("@UserID", laby.UserID),
                    new SqlParameter("@myProgress", laby.myProgress),
                    new SqlParameter("@myRanking", laby.myRanking),
                    new SqlParameter("@completeChallenge", laby.completeChallenge),
                    new SqlParameter("@isDoubleAward", laby.isDoubleAward),
                    new SqlParameter("@currentFloor", laby.currentFloor),
                    new SqlParameter("@accumulateExp", laby.accumulateExp),
                    new SqlParameter("@remainTime", laby.remainTime),
                    new SqlParameter("@currentRemainTime", laby.currentRemainTime),
                    new SqlParameter("@cleanOutAllTime", laby.cleanOutAllTime),
                    new SqlParameter("@cleanOutGold", laby.cleanOutGold),
                    new SqlParameter("@tryAgainComplete", laby.tryAgainComplete),
                    new SqlParameter("@isInGame", laby.isInGame),
                    new SqlParameter("@isCleanOut", laby.isCleanOut),
                    new SqlParameter("@serverMultiplyingPower", laby.serverMultiplyingPower),
                    new SqlParameter("@LastDate", laby.LastDate),
                    new SqlParameter("@ProcessAward", laby.ProcessAward),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[17].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateLabyrinthInfo", SqlParameters);
                flag = true;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateLabyrinthInfo", ex);
                    return flag;
                }
                return flag;
            }
        }

        public UserGiftInfo[] GetAllUserGifts(int userid, bool isReceive)
        {
            List<UserGiftInfo> userGiftInfoList = new List<UserGiftInfo>();
            SqlDataReader ResultDataReader = null;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[2]
                {
                    new SqlParameter("@UserID", userid),
                    new SqlParameter("@IsReceive", isReceive)
                };
                db.GetReader(ref ResultDataReader, "SP_Users_Gift_Single", SqlParameters);
                while (ResultDataReader.Read())
                {
                    userGiftInfoList.Add(new UserGiftInfo
                    {
                        ID = (int)ResultDataReader["ID"],
                        ReceiverID = (int)ResultDataReader["ReceiverID"],
                        SenderID = (int)ResultDataReader["SenderID"],
                        TemplateID = (int)ResultDataReader["TemplateID"],
                        Count = (int)ResultDataReader["Count"],
                        CreateDate = (DateTime)ResultDataReader["CreateDate"],
                        LastUpdate = (DateTime)ResultDataReader["LastUpdate"]
                    });
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetAllUserGifts", ex);
                }
            }
            finally
            {
                if (ResultDataReader != null && !ResultDataReader.IsClosed)
                {
                    ResultDataReader.Close();
                }
            }
            return userGiftInfoList.ToArray();
        }

        public UserGiftInfo[] GetAllUserReceivedGifts(int userid)
        {
            Dictionary<int, UserGiftInfo> dictionary = new Dictionary<int, UserGiftInfo>();
            SqlDataReader sqlDataReader = null;
            try
            {
                UserGiftInfo[] allUserGifts = GetAllUserGifts(userid, isReceive: true);
                if (allUserGifts != null)
                {
                    UserGiftInfo[] array = allUserGifts;
                    UserGiftInfo[] array2 = array;
                    foreach (UserGiftInfo userGiftInfo in array2)
                    {
                        if (dictionary.ContainsKey(userGiftInfo.TemplateID))
                        {
                            dictionary[userGiftInfo.TemplateID].Count += userGiftInfo.Count;
                        }
                        else
                        {
                            dictionary.Add(userGiftInfo.TemplateID, userGiftInfo);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetAllUserReceivedGifts", ex);
                }
            }
            finally
            {
                if (sqlDataReader != null && !sqlDataReader.IsClosed)
                {
                    sqlDataReader.Close();
                }
            }
            return dictionary.Values.ToArray();
        }

        public bool AddUserGift(UserGiftInfo info)
        {
            bool flag = false;
            try
            {
                db.RunProcedure("SP_Users_Gift_Add", new SqlParameter[4]
                {
                    new SqlParameter("@SenderID", info.SenderID),
                    new SqlParameter("@ReceiverID", info.ReceiverID),
                    new SqlParameter("@TemplateID", info.TemplateID),
                    new SqlParameter("@Count", info.Count)
                });
                flag = true;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("AddUserGift", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool UpdateUserCharmGP(int userId, int int_1)
        {
            bool flag = false;
            try
            {
                SqlParameter[] SqlParameters = new SqlParameter[3]
                {
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@CharmGP", int_1),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                SqlParameters[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Users_UpdateCharmGP", SqlParameters);
                flag = (int)SqlParameters[2].Value == 0;
                return flag;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("AddUserGift", ex);
                    return flag;
                }
                return flag;
            }
        }

        public bool ResetEliteGame(int point)
        {
            bool flag = false;
            try
            {
                return db.RunProcedure("SP_EliteGame_Reset", new SqlParameter[1]
                {
                    new SqlParameter("@EliteScore", point)
                });
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", ex);
                    return flag;
                }
                return flag;
            }
        }

        public EatPetsInfo GetAllEatPetsByID(int ID)
        {
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                para[0].Value = ID;
                db.GetReader(ref reader, "SP_Sys_Eat_Pets_All", para);
                if (reader.Read())
                {
                    return InitEatPetsInfo(reader);
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("InitEatPetsInfo", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return null;
        }

        public EatPetsInfo InitEatPetsInfo(SqlDataReader dr)
        {
            EatPetsInfo info = new EatPetsInfo();
            info.ID = (int)dr["ID"];
            info.UserID = (int)dr["UserID"];
            info.weaponExp = (int)dr["weaponExp"];
            info.weaponLevel = (int)dr["weaponLevel"];
            info.clothesExp = (int)dr["clothesExp"];
            info.clothesLevel = (int)dr["clothesLevel"];
            info.hatExp = (int)dr["hatExp"];
            info.hatLevel = (int)dr["hatLevel"];
            return info;
        }

        public bool UpdateEatPets(EatPetsInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[8]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@weaponExp", info.weaponExp),
                    new SqlParameter("@weaponLevel", info.weaponLevel),
                    new SqlParameter("@clothesExp", info.clothesExp),
                    new SqlParameter("@clothesLevel", info.clothesLevel),
                    new SqlParameter("@hatExp", info.hatExp),
                    new SqlParameter("@hatLevel", info.hatLevel)
                };
                result = db.RunProcedure("SP_Sys_Eat_Pets_Update", para);
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_Sys_Eat_Pets_Update", e);
                }
            }
            return result;
        }

        public bool AddEatPets(EatPetsInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[8]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@weaponExp", info.weaponExp),
                    new SqlParameter("@weaponLevel", info.weaponLevel),
                    new SqlParameter("@clothesExp", info.clothesExp),
                    new SqlParameter("@clothesLevel", info.clothesLevel),
                    new SqlParameter("@hatExp", info.hatExp),
                    new SqlParameter("@hatLevel", info.hatLevel)
                };
                para[0].Direction = ParameterDirection.Output;
                result = db.RunProcedure("SP_Sys_Eat_Pets_Add", para);
                info.ID = (int)para[0].Value;
                info.IsDirty = false;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_Sys_Eat_Pets_Add", e);
                }
            }
            return result;
        }

        public Suit_Manager Get_Suit_Manager(int UserID)
        {
            Suit_Manager items = new Suit_Manager();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para2 = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para2[0].Value = UserID;
                db.GetReader(ref reader, "SP_Suit_Manager_GET", para2);
                while (reader.Read())
                {
                    items.UserID = (int)reader["UserID"];
                    items.Kill_List = (string)reader["Kill_List"];
                }
            }
            catch (Exception e2)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e2);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            try
            {
                if (items.UserID == 0)
                {
                    try
                    {
                        SqlParameter[] para = new SqlParameter[1]
                        {
                            new SqlParameter("@UserID", UserID)
                        };
                        db.RunProcedure("SP_Suit_Manager_ADD", para);
                    }
                    catch (Exception e)
                    {
                        if (BaseBussiness.log.IsErrorEnabled)
                        {
                            BaseBussiness.log.Error("SP_Suit_Manager_ADD error!", e);
                        }
                    }
                }
            }
            catch
            {
            }
            return items;
        }

        public bool UpdateRank()
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[0];
                result = db.RunProcedure("SP_Sys_Update_Consortia_DayList", para);
                result = db.RunProcedure("SP_Sys_Update_Consortia_FightPower", para);
                result = db.RunProcedure("SP_Sys_Update_Consortia_Honor", para);
                result = db.RunProcedure("SP_Sys_Update_Consortia_List", para);
                result = db.RunProcedure("SP_Sys_Update_Consortia_WeekList", para);
                result = db.RunProcedure("SP_Sys_Update_OfferList", para);
                result = db.RunProcedure("SP_Sys_Update_Users_DayList", para);
                result = db.RunProcedure("SP_Sys_Update_Users_List", para);
                result = db.RunProcedure("SP_Sys_Update_Users_WeekList", para);
                result = db.RunProcedure("SP_Sys_Update_Users_Rank_Date", para);
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init UpdatePersonalRank", e);
                }
            }
            return result;
        }

        public UserRankDateInfo[] GetAllUserRankDate()
        {
            List<UserRankDateInfo> list = new List<UserRankDateInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[0];
                db.GetReader(ref reader, "SP_Sys_Users_Rank_Date_All", para);
                while (reader.Read())
                {
                    list.Add(InitUserRankDateInfo(reader));
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("InitUserRankDateInfo", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return list.ToArray();
        }

        public UserRankDateInfo GetUserRankDateByID(int userID)
        {
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = userID;
                db.GetReader(ref reader, "SP_Sys_Users_Rank_Date", para);
                if (reader.Read())
                {
                    return InitUserRankDateInfo(reader);
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("InitUserRankDateInfo", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return null;
        }

        public UserRankDateInfo InitUserRankDateInfo(SqlDataReader dr)
        {
            UserRankDateInfo info = new UserRankDateInfo();
            info.UserID = (int)dr["UserID"];
            info.ConsortiaID = (int)dr["ConsortiaID"];
            info.FightPower = (int)dr["FightPower"];
            info.PrevFightPower = (int)dr["PrevFightPower"];
            info.GP = (int)dr["GP"];
            info.PrevGP = (int)dr["PrevGP"];
            info.AchievementPoint = (int)dr["AchievementPoint"];
            info.PrevAchievementPoint = (int)dr["PrevAchievementPoint"];
            info.charmGP = (int)dr["charmGP"];
            info.PrecharmGP = (int)dr["PrecharmGP"];
            info.LeagueAddWeek = (int)dr["LeagueAddWeek"];
            info.PrevLeagueAddWeek = (int)dr["PrevLeagueAddWeek"];
            info.ConsortiaFightPower = (int)dr["ConsortiaFightPower"];
            info.ConsortiaPrevFightPower = (int)dr["ConsortiaPrevFightPower"];
            info.ConsortiaLevel = (int)dr["ConsortiaLevel"];
            info.ConsortiaPrevLevel = (int)dr["ConsortiaPrevLevel"];
            info.ConsortiaRiches = (int)dr["ConsortiaRiches"];
            info.ConsortiaPrevRiches = (int)dr["ConsortiaPrevRiches"];
            info.ConsortiacharmGP = (int)dr["ConsortiacharmGP"];
            info.ConsortiaPrevcharmGP = (int)dr["ConsortiaPrevcharmGP"];
            return info;
        }

        public UsersPetInfo[] GetUserAdoptPetSingles(int UserID)
        {
            List<UsersPetInfo> items = new List<UsersPetInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = UserID;
                db.GetReader(ref reader, "SP_Get_User_AdoptPetList", para);
                while (reader.Read())
                {
                    UsersPetInfo info = new UsersPetInfo();
                    info.ID = (int)reader["ID"];
                    info.TemplateID = (int)reader["TemplateID"];
                    info.Name = reader["Name"].ToString();
                    info.UserID = (int)reader["UserID"];
                    info.Attack = (int)reader["Attack"];
                    info.AttackGrow = (int)reader["AttackGrow"];
                    info.Agility = (int)reader["Agility"];
                    info.AgilityGrow = (int)reader["AgilityGrow"];
                    info.Defence = (int)reader["Defence"];
                    info.DefenceGrow = (int)reader["DefenceGrow"];
                    info.Luck = (int)reader["Luck"];
                    info.LuckGrow = (int)reader["LuckGrow"];
                    info.Blood = (int)reader["Blood"];
                    info.BloodGrow = (int)reader["BloodGrow"];
                    info.Damage = (int)reader["Damage"];
                    info.DamageGrow = (int)reader["DamageGrow"];
                    info.Guard = (int)reader["Guard"];
                    info.GuardGrow = (int)reader["GuardGrow"];
                    info.Level = (int)reader["Level"];
                    info.GP = (int)reader["GP"];
                    info.MaxGP = (int)reader["MaxGP"];
                    info.Hunger = (int)reader["Hunger"];
                    info.MP = (int)reader["MP"];
                    info.Place = (int)reader["Place"];
                    info.IsEquip = (bool)reader["IsEquip"];
                    info.IsExit = (bool)reader["IsExit"];
                    info.Skill = reader["Skill"].ToString();
                    info.SkillEquip = reader["SkillEquip"].ToString();
                    items.Add(info);
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return items.ToArray();
        }

        public UserFarmInfo GetSingleFarm(int Id)
        {
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                para[0].Value = Id;
                db.GetReader(ref reader, "SP_Get_SingleFarm", para);
                if (reader.Read())
                {
                    UserFarmInfo infos = new UserFarmInfo();
                    infos.ID = (int)reader["ID"];
                    infos.FarmID = (int)reader["FarmID"];
                    infos.PayFieldMoney = (string)reader["PayFieldMoney"];
                    infos.PayAutoMoney = (string)reader["PayAutoMoney"];
                    infos.AutoPayTime = (DateTime)reader["AutoPayTime"];
                    infos.AutoValidDate = (int)reader["AutoValidDate"];
                    infos.VipLimitLevel = (int)reader["VipLimitLevel"];
                    infos.FarmerName = (string)reader["FarmerName"];
                    infos.GainFieldId = (int)reader["GainFieldId"];
                    infos.MatureId = (int)reader["MatureId"];
                    infos.KillCropId = (int)reader["KillCropId"];
                    infos.isAutoId = (int)reader["isAutoId"];
                    infos.isFarmHelper = (bool)reader["isFarmHelper"];
                    infos.buyExpRemainNum = (int)reader["buyExpRemainNum"];
                    infos.isArrange = (bool)reader["isArrange"];
                    infos.TreeLevel = (int)reader["TreeLevel"];
                    infos.TreeExp = (int)reader["TreeExp"];
                    infos.LoveScore = (int)reader["LoveScore"];
                    infos.MonsterExp = (int)reader["MonsterExp"];
                    infos.PoultryState = (int)reader["PoultryState"];
                    infos.CountDownTime = (DateTime)reader["CountDownTime"];
                    infos.TreeCostExp = (int)reader["TreeCostExp"];
                    return infos;
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetSingleFarm", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return null;
        }

        public bool AddFarm(UserFarmInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[22]
                {
                    new SqlParameter("@FarmID", info.FarmID),
                    new SqlParameter("@PayFieldMoney", info.PayFieldMoney),
                    new SqlParameter("@PayAutoMoney", info.PayAutoMoney),
                    new SqlParameter("@AutoPayTime", info.AutoPayTime),
                    new SqlParameter("@AutoValidDate", info.AutoValidDate),
                    new SqlParameter("@VipLimitLevel", info.VipLimitLevel),
                    new SqlParameter("@FarmerName", info.FarmerName),
                    new SqlParameter("@GainFieldId", info.GainFieldId),
                    new SqlParameter("@MatureId", info.MatureId),
                    new SqlParameter("@KillCropId", info.KillCropId),
                    new SqlParameter("@isAutoId", info.isAutoId),
                    new SqlParameter("@isFarmHelper", info.isFarmHelper),
                    new SqlParameter("@ID", info.ID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                para[12].Direction = ParameterDirection.Output;
                para[13] = new SqlParameter("@buyExpRemainNum", info.buyExpRemainNum);
                para[14] = new SqlParameter("@isArrange", info.isArrange);
                para[15] = new SqlParameter("@TreeLevel", info.TreeLevel);
                para[16] = new SqlParameter("@TreeExp", info.TreeExp);
                para[17] = new SqlParameter("@LoveScore", info.LoveScore);
                para[18] = new SqlParameter("@MonsterExp", info.MonsterExp);
                para[19] = new SqlParameter("@PoultryState", info.PoultryState);
                para[20] = new SqlParameter("@CountDownTime", info.CountDownTime);
                para[21] = new SqlParameter("@TreeCostExp", info.TreeCostExp);
                result = db.RunProcedure("SP_Users_Farm_Add", para);
                info.ID = (int)para[12].Value;
                info.IsDirty = false;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            finally
            {
            }
            return result;
        }

        public bool UpdateFarm(UserFarmInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[22]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@FarmID", info.FarmID),
                    new SqlParameter("@PayFieldMoney", info.PayFieldMoney),
                    new SqlParameter("@PayAutoMoney", info.PayAutoMoney),
                    new SqlParameter("@AutoPayTime", info.AutoPayTime),
                    new SqlParameter("@AutoValidDate", info.AutoValidDate),
                    new SqlParameter("@VipLimitLevel", info.VipLimitLevel),
                    new SqlParameter("@FarmerName", info.FarmerName),
                    new SqlParameter("@GainFieldId", info.GainFieldId),
                    new SqlParameter("@MatureId", info.MatureId),
                    new SqlParameter("@KillCropId", info.KillCropId),
                    new SqlParameter("@isAutoId", info.isAutoId),
                    new SqlParameter("@isFarmHelper", info.isFarmHelper),
                    new SqlParameter("@buyExpRemainNum", info.buyExpRemainNum),
                    new SqlParameter("@isArrange", info.isArrange),
                    new SqlParameter("@TreeLevel", info.TreeLevel),
                    new SqlParameter("@TreeExp", info.TreeExp),
                    new SqlParameter("@LoveScore", info.LoveScore),
                    new SqlParameter("@MonsterExp", info.MonsterExp),
                    new SqlParameter("@PoultryState", info.PoultryState),
                    new SqlParameter("@CountDownTime", info.CountDownTime),
                    new SqlParameter("@TreeCostExp", info.TreeCostExp)
                };
                result = db.RunProcedure("SP_Users_Farm_Update", para);
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            return result;
        }

        public UserFieldInfo[] GetSingleFields(int ID)
        {
            List<UserFieldInfo> infos = new List<UserFieldInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@ID", SqlDbType.Int, 4)
                };
                para[0].Value = ID;
                db.GetReader(ref reader, "SP_Get_SingleFields", para);
                while (reader.Read())
                {
                    UserFieldInfo info = new UserFieldInfo();
                    info.ID = (int)reader["ID"];
                    info.FarmID = (int)reader["FarmID"];
                    info.FieldID = (int)reader["FieldID"];
                    info.SeedID = (int)reader["SeedID"];
                    info.PlantTime = (DateTime)reader["PlantTime"];
                    info.AccelerateTime = (int)reader["AccelerateTime"];
                    info.FieldValidDate = (int)reader["FieldValidDate"];
                    info.PayTime = (DateTime)reader["PayTime"];
                    info.GainCount = (int)reader["GainCount"];
                    info.AutoSeedID = (int)reader["AutoSeedID"];
                    info.AutoFertilizerID = (int)reader["AutoFertilizerID"];
                    info.AutoSeedIDCount = (int)reader["AutoSeedIDCount"];
                    info.AutoFertilizerCount = (int)reader["AutoFertilizerCount"];
                    info.isAutomatic = (bool)reader["isAutomatic"];
                    info.AutomaticTime = (DateTime)reader["AutomaticTime"];
                    info.IsExit = (bool)reader["IsExit"];
                    info.payFieldTime = (int)reader["payFieldTime"];
                    infos.Add(info);
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_GetSingleFields", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return infos.ToArray();
        }

        public bool AddFields(UserFieldInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[17]
                {
                    new SqlParameter("@FarmID", item.FarmID),
                    new SqlParameter("@FieldID", item.FieldID),
                    new SqlParameter("@SeedID", item.SeedID),
                    new SqlParameter("@PlantTime", item.PlantTime),
                    new SqlParameter("@AccelerateTime", item.AccelerateTime),
                    new SqlParameter("@FieldValidDate", item.FieldValidDate),
                    new SqlParameter("@PayTime", item.PayTime),
                    new SqlParameter("@GainCount", item.GainCount),
                    new SqlParameter("@AutoSeedID", item.AutoSeedID),
                    new SqlParameter("@AutoFertilizerID", item.AutoFertilizerID),
                    new SqlParameter("@AutoSeedIDCount", item.AutoSeedIDCount),
                    new SqlParameter("@AutoFertilizerCount", item.AutoFertilizerCount),
                    new SqlParameter("@isAutomatic", item.isAutomatic),
                    new SqlParameter("@AutomaticTime", item.AutomaticTime),
                    new SqlParameter("@IsExit", item.IsExit),
                    new SqlParameter("@payFieldTime", item.payFieldTime),
                    new SqlParameter("@ID", item.ID)
                };
                para[16].Direction = ParameterDirection.Output;
                result = db.RunProcedure("SP_Users_Fields_Add", para);
                item.ID = (int)para[16].Value;
                item.IsDirty = false;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            finally
            {
            }
            return result;
        }

        public bool UpdateFields(UserFieldInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[17]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@FarmID", info.FarmID),
                    new SqlParameter("@FieldID", info.FieldID),
                    new SqlParameter("@SeedID", info.SeedID),
                    new SqlParameter("@PlantTime", info.PlantTime),
                    new SqlParameter("@AccelerateTime", info.AccelerateTime),
                    new SqlParameter("@FieldValidDate", info.FieldValidDate),
                    new SqlParameter("@PayTime", info.PayTime),
                    new SqlParameter("@GainCount", info.GainCount),
                    new SqlParameter("@AutoSeedID", info.AutoSeedID),
                    new SqlParameter("@AutoFertilizerID", info.AutoFertilizerID),
                    new SqlParameter("@AutoSeedIDCount", info.AutoSeedIDCount),
                    new SqlParameter("@AutoFertilizerCount", info.AutoFertilizerCount),
                    new SqlParameter("@isAutomatic", info.isAutomatic),
                    new SqlParameter("@AutomaticTime", info.AutomaticTime),
                    new SqlParameter("@IsExit", info.IsExit),
                    new SqlParameter("@payFieldTime", info.payFieldTime)
                };
                result = db.RunProcedure("SP_Users_Fields_Update", para);
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", e);
                }
            }
            return result;
        }

        public NewChickenBoxItemInfo[] GetSingleNewChickenBox(int UserID)
        {
            List<NewChickenBoxItemInfo> list = new List<NewChickenBoxItemInfo>();
            SqlDataReader sqlDataReader = null;
            try
            {
                SqlParameter[] array = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                array[0].Value = UserID;
                db.GetReader(ref sqlDataReader, "SP_GetSingleNewChickenBox", array);
                while (sqlDataReader.Read())
                {
                    list.Add(new NewChickenBoxItemInfo
                    {
                        ID = (int)sqlDataReader["ID"],
                        UserID = (int)sqlDataReader["UserID"],
                        TemplateID = (int)sqlDataReader["TemplateID"],
                        Count = (int)sqlDataReader["Count"],
                        ValidDate = (int)sqlDataReader["ValidDate"],
                        StrengthenLevel = (int)sqlDataReader["StrengthenLevel"],
                        AttackCompose = (int)sqlDataReader["AttackCompose"],
                        DefendCompose = (int)sqlDataReader["DefendCompose"],
                        AgilityCompose = (int)sqlDataReader["AgilityCompose"],
                        LuckCompose = (int)sqlDataReader["LuckCompose"],
                        Position = (int)sqlDataReader["Position"],
                        IsSelected = (bool)sqlDataReader["IsSelected"],
                        IsSeeded = (bool)sqlDataReader["IsSeeded"],
                        IsBinds = (bool)sqlDataReader["IsBinds"]
                    });
                }
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_GetSingleNewChickenBox", ex);
                }
            }
            finally
            {
                if (sqlDataReader != null && !sqlDataReader.IsClosed)
                {
                    sqlDataReader.Close();
                }
            }
            return list.ToArray();
        }

        public bool AddNewChickenBox(NewChickenBoxItemInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] array = new SqlParameter[15]
                {
                    new SqlParameter("@ID", info.ID),
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null,
                    null
                };
                array[0].Direction = ParameterDirection.Output;
                array[1] = new SqlParameter("@UserID", info.UserID);
                array[2] = new SqlParameter("@TemplateID", info.TemplateID);
                array[3] = new SqlParameter("@Count", info.Count);
                array[4] = new SqlParameter("@ValidDate", info.ValidDate);
                array[5] = new SqlParameter("@StrengthenLevel", info.StrengthenLevel);
                array[6] = new SqlParameter("@AttackCompose", info.AttackCompose);
                array[7] = new SqlParameter("@DefendCompose", info.DefendCompose);
                array[8] = new SqlParameter("@AgilityCompose", info.AgilityCompose);
                array[9] = new SqlParameter("@LuckCompose", info.LuckCompose);
                array[10] = new SqlParameter("@Position", info.Position);
                array[11] = new SqlParameter("@IsSelected", info.IsSelected);
                array[12] = new SqlParameter("@IsSeeded", info.IsSeeded);
                array[13] = new SqlParameter("@IsBinds", info.IsBinds);
                array[14] = new SqlParameter("@Result", SqlDbType.Int);
                array[14].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_NewChickenBox_Add", array);
                result = (int)array[14].Value == 0;
                info.ID = (int)array[0].Value;
                info.IsDirty = false;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_NewChickenBox_Add", ex);
                }
            }
            return result;
        }

        public bool UpdateNewChickenBox(NewChickenBoxItemInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] array = new SqlParameter[15]
                {
                    new SqlParameter("@ID", info.ID),
                    new SqlParameter("@UserID", info.UserID),
                    new SqlParameter("@TemplateID", info.TemplateID),
                    new SqlParameter("@Count", info.Count),
                    new SqlParameter("@ValidDate", info.ValidDate),
                    new SqlParameter("@StrengthenLevel", info.StrengthenLevel),
                    new SqlParameter("@AttackCompose", info.AttackCompose),
                    new SqlParameter("@DefendCompose", info.DefendCompose),
                    new SqlParameter("@AgilityCompose", info.AgilityCompose),
                    new SqlParameter("@LuckCompose", info.LuckCompose),
                    new SqlParameter("@Position", info.Position),
                    new SqlParameter("@IsSelected", info.IsSelected),
                    new SqlParameter("@IsSeeded", info.IsSeeded),
                    new SqlParameter("@IsBinds", info.IsBinds),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                array[14].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateNewChickenBox", array);
                result = (int)array[14].Value == 0;
            }
            catch (Exception ex)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateNewChickenBox", ex);
                }
            }
            return result;
        }

        public ActiveSystemInfo GetSingleActiveSystem(int UserID)
        {
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                para[0].Value = UserID;
                db.GetReader(ref reader, "SP_GetSingleActiveSystem", para);
                if (reader.Read())
                {
                    return new ActiveSystemInfo
                    {
                        ID = (int)reader["ID"],
                        UserID = (int)reader["UserID"],
                        canEagleEyeCounts = (int)reader["canEagleEyeCounts"],
                        canOpenCounts = (int)reader["canOpenCounts"],
                        isShowAll = (bool)reader["isShowAll"],
                        lastFlushTime = (DateTime)reader["lastFlushTime"],
                        ChickActiveData = reader["ChickActiveData"] == DBNull.Value ? "" : reader["ChickActiveData"].ToString(),
                        LuckystarCoins = (int)reader["LuckystarCoins"],
                        ActiveMoney = (int)reader["ActiveMoney"],
                    };
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("GetSingleActiveSystem", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return null;
        }

        public bool AddActiveSystem(ActiveSystemInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[10]
                {
                new SqlParameter("@ID", info.ID),
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null
                };
                para[0].Direction = ParameterDirection.Output;
                para[1] = new SqlParameter("@UserID", info.UserID);
                para[2] = new SqlParameter("@canEagleEyeCounts", info.canEagleEyeCounts);
                para[3] = new SqlParameter("@canOpenCounts", info.canOpenCounts);
                para[4] = new SqlParameter("@isShowAll", info.isShowAll);
                para[5] = new SqlParameter("@lastFlushTime", info.lastFlushTime);
                para[6] = new SqlParameter("@ChickActiveData", info.ChickActiveData);
                para[7] = new SqlParameter("@LuckystarCoins", info.LuckystarCoins);
                para[8] = new SqlParameter("@ActiveMoney", info.ActiveMoney);
                para[9] = new SqlParameter("@Result", SqlDbType.Int);
                para[9].Direction = ParameterDirection.ReturnValue;

                db.RunProcedure("SP_ActiveSystem_Add", para);
                result = (int)para[9].Value == 0;
                info.ID = (int)para[0].Value;
                info.IsDirty = false;
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("AddActiveSystem", e);
                }
            }
            return result;
        }

        //public bool AddActiveSystem(ActiveSystemInfo item)
        //{
        //	bool result = false;
        //	try
        //	{
        //		SqlParameter[] para = new SqlParameter[8];
        //		para[0] = new SqlParameter("@ID", item.ID);
        //		para[0].Direction = ParameterDirection.Output;
        //		para[1] = new SqlParameter("@UserID", item.UserID);
        //		para[2] = new SqlParameter("@canEagleEyeCounts", item.canEagleEyeCounts);
        //		para[3] = new SqlParameter("@canOpenCounts", item.canOpenCounts);
        //		para[4] = new SqlParameter("@isShowAll", item.isShowAll);
        //		para[5] = new SqlParameter("@lastFlushTime", item.lastFlushTime);
        //		para[6] = new SqlParameter("@ChickActiveData", item.ChickActiveData);
        //		para[7] = new SqlParameter("@Result", SqlDbType.Int);
        //		para[7].Direction = ParameterDirection.ReturnValue;
        //		db.RunProcedure("SP_ActiveSystem_Add", para);
        //		result = (int)para[7].Value == 0;
        //		item.ID = (int)para[0].Value;
        //		item.IsDirty = false;
        //	}
        //	catch (Exception e)
        //	{
        //		if (log.IsErrorEnabled)
        //			log.Error("AddActiveSystem", e);
        //	}
        //	return result;
        //}

        public bool UpdateActiveSystem(ActiveSystemInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[10];
                para[0] = new SqlParameter("@ID", item.ID);
                para[1] = new SqlParameter("@UserID", item.UserID);
                para[2] = new SqlParameter("@canOpenCounts", item.canOpenCounts);
                para[3] = new SqlParameter("@canEagleEyeCounts", item.canEagleEyeCounts);
                para[4] = new SqlParameter("@lastFlushTime", item.lastFlushTime);
                para[5] = new SqlParameter("@isShowAll", item.isShowAll);
                para[6] = new SqlParameter("@ChickActiveData", item.ChickActiveData);
                para[7] = new SqlParameter("@LuckystarCoins", item.LuckystarCoins);
                para[8] = new SqlParameter("@ActiveMoney", item.ActiveMoney);
                para[9] = new SqlParameter("@Result", SqlDbType.Int);
                para[9].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Active_System_Data_Update", para);
                result = (int)para[9].Value == 0;
            }
            catch (Exception Err)
            {
                if (log.IsErrorEnabled)
                    log.Error("UpdateActiveSystem", Err);
            }

            return result;
        }

        public ConsortiaWithTaskInfo[] GetConsortiaTaskInfos()
        {
            List<ConsortiaWithTaskInfo> list = new List<ConsortiaWithTaskInfo>();
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[0];
                db.GetReader(ref reader, "SP_Consortia_Task_Info_All", para);
                while (reader.Read())
                {
                    list.Add(InitConsortiaTaskInfo(reader));
                }
            }
            catch (Exception e)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("InitConsortiaTaskInfo", e);
                }
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                {
                    reader.Close();
                }
            }
            return list.ToArray();
        }

        public bool CreateOrUpdateConsortiaTaskInfo(ConsortiaWithTaskInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[12];
                para[0] = new SqlParameter("@ConsortiaID", item.ConsortiaID);
                para[1] = new SqlParameter("@BeginTime", item.BeginTime);
                para[2] = new SqlParameter("@Contribution", item.Contribution);
                para[3] = new SqlParameter("@Expirience", item.Expirience);
                para[4] = new SqlParameter("@Offer", item.Offer);
                para[5] = new SqlParameter("@BuffID", item.BuffID);
                para[6] = new SqlParameter("@Level", item.Level);
                para[7] = new SqlParameter("@Riches", item.Riches);
                para[8] = new SqlParameter("@Time", item.Time);
                para[9] = new SqlParameter("@ConditionData", item.ConditionData);
                para[10] = new SqlParameter("@RankTable", item.RankTable);
                para[11] = new SqlParameter("@Result", SqlDbType.Int);
                para[11].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Consortia_Task_Info_Create_Or_Update", para);
                result = (int)para[11].Value == 0;
            }
            catch (Exception Err)
            {
                if (log.IsErrorEnabled)
                    log.Error("CreateOrUpdateConsortiaTaskInfo", Err);
            }

            return result;
        }

        public bool RemoveConsortiaTaskInfo(int ConsortiaID)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[2];
                para[0] = new SqlParameter("@ConsortiaID", ConsortiaID);
                para[1] = new SqlParameter("@Result", SqlDbType.Int);
                para[1].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Consortia_Task_Info_Delete", para);
                result = (int)para[1].Value == 0;
            }
            catch (Exception Err)
            {
                if (log.IsErrorEnabled)
                    log.Error("RemoveConsortiaTaskInfo", Err);
            }

            return result;
        }

        public ConsortiaWithTaskInfo InitConsortiaTaskInfo(SqlDataReader dr)
        {
            ConsortiaWithTaskInfo info = new ConsortiaWithTaskInfo();
            info.ID = (int)dr["ID"];
            info.ConsortiaID = (int)dr["ConsortiaID"];
            info.BeginTime = (DateTime)dr["BeginTime"];
            info.Contribution = (int)dr["Contribution"];
            info.Expirience = (int)dr["Expirience"];
            info.Offer = (int)dr["Offer"];
            info.BuffID = (int)dr["BuffID"];
            info.Level = (int)dr["Level"];
            info.Riches = (int)dr["Riches"];
            info.Time = (int)dr["Time"];
            info.ConditionData = (dr["ConditionData"] == DBNull.Value) ? string.Empty : (string)dr["ConditionData"];
            info.RankTable = (dr["RankTable"] == DBNull.Value) ? string.Empty : (string)dr["RankTable"];
            return info;
        }

        public int ActiveChickCode(int UserID, string Code)
        {
            int result = 3;
            try
            {
                SqlParameter[] para = new SqlParameter[3];
                para[0] = new SqlParameter("@UserID", UserID);
                para[1] = new SqlParameter("@ActiveCode", Code);
                para[2] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[2].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_Active_ChickCode", para);
                result = (int)para[2].Value;
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            return result;
        }

        public bool DeleteAllActive()
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[0];
                result = db.RunProcedure("SP_Active_Delete", para);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("SP_Active_Delete", e);
            }
            return result;
        }

        public bool AddActive(ActiveInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[19];
                para[0] = new SqlParameter("@ActiveID", info.ActiveID);
                para[1] = new SqlParameter("@Description", info.Description);
                para[2] = new SqlParameter("@Content", info.Content);
                para[3] = new SqlParameter("@AwardContent", info.AwardContent);
                para[4] = new SqlParameter("@HasKey", info.HasKey);
                para[5] = new SqlParameter("@EndDate", info.EndDate);
                para[6] = new SqlParameter("@IsOnly", info.IsOnly);
                para[7] = new SqlParameter("@StartDate", info.StartDate);
                para[8] = new SqlParameter("@Title", info.Title);
                para[9] = new SqlParameter("@Type", info.Type);
                para[10] = new SqlParameter("@ActiveType", info.ActiveType);
                para[11] = new SqlParameter("@ActionTimeContent", info.ActionTimeContent);
                para[12] = new SqlParameter("@IsAdvance", info.IsAdvance);
                para[13] = new SqlParameter("@GoodsExchangeTypes", info.GoodsExchangeTypes);
                para[14] = new SqlParameter("@GoodsExchangeNum", info.GoodsExchangeNum);
                para[15] = new SqlParameter("@limitType", info.limitType);
                para[16] = new SqlParameter("@limitValue", info.limitValue);
                para[17] = new SqlParameter("@IsShow", info.IsShow);
                para[18] = new SqlParameter("@IconID", info.IconID);
                result = db.RunProcedure("SP_Active_Add", para);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("SP_Active_Add", e);
            }
            return result;
        }

        public bool AddActiveAward(ActiveAwardInfo info)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[13];
                para[0] = new SqlParameter("@ActiveID", info.ActiveID);
                para[1] = new SqlParameter("@ItemID", info.ItemID);
                para[2] = new SqlParameter("@Count", info.Count);
                para[3] = new SqlParameter("@ValidDate", info.ValidDate);
                para[4] = new SqlParameter("@StrengthenLevel", info.StrengthenLevel);
                para[5] = new SqlParameter("@AttackCompose", info.AttackCompose);
                para[6] = new SqlParameter("@DefendCompose", info.DefendCompose);
                para[7] = new SqlParameter("@LuckCompose", info.LuckCompose);
                para[8] = new SqlParameter("@AgilityCompose", info.AgilityCompose);
                para[9] = new SqlParameter("@Gold", info.Gold);
                para[10] = new SqlParameter("@Money", info.Money);
                para[11] = new SqlParameter("@Sex", info.Sex);
                para[12] = new SqlParameter("@Mark", info.Mark);
                result = db.RunProcedure("SP_Active_Award", para);
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("SP_Active_Award_Add", e);
            }
            return result;
        }

        public LuckstarActivityRankInfo[] GetAllLuckstarActivityRank()
        {
            List<LuckstarActivityRankInfo> infos = new List<LuckstarActivityRankInfo>();
            SqlDataReader reader = null;
            try
            {
                db.GetReader(ref reader, "SP_Luckstar_Activity_Rank_All");
                int rank = 1;
                while (reader.Read())
                {
                    LuckstarActivityRankInfo info = new LuckstarActivityRankInfo();
                    info.rank = rank;
                    info.UserID = (int)reader["UserID"];
                    info.useStarNum = (int)reader["useStarNum"];
                    info.isVip = (int)reader["isVip"];
                    info.nickName = (string)reader["nickName"];
                    infos.Add(info);
                    rank++;
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                    reader.Close();
            }
            return infos.ToArray();
        }

        public UserGemStone InitGemStones(SqlDataReader reader)
        {
            return new UserGemStone()
            {
                ID = (int)reader["ID"],
                UserID = (int)reader["UserID"],
                FigSpiritId = (int)reader["FigSpiritId"],
                FigSpiritIdValue = (string)reader["FigSpiritIdValue"],
                EquipPlace = (int)reader["EquipPlace"]
            };
        }


        public List<UserGemStone> GetSingleGemStones(int ID)
        {
            List<UserGemStone> userGemStones = new List<UserGemStone>();
            SqlDataReader sqlDataReader = null;
            try
            {
                try
                {
                    SqlParameter[] sqlParameter = new SqlParameter[] { new SqlParameter("@ID", SqlDbType.Int, 4) };
                    sqlParameter[0].Value = ID;
                    this.db.GetReader(ref sqlDataReader, "SP_GetSingleGemStone", sqlParameter);
                    while (sqlDataReader.Read())
                    {
                        userGemStones.Add(this.InitGemStones(sqlDataReader));
                    }
                }
                catch (Exception exception1)
                {
                    Exception exception = exception1;
                    if (BaseBussiness.log.IsErrorEnabled)
                    {
                        BaseBussiness.log.Error("SP_GetSingleUserGemStones", exception);
                    }
                }
            }
            finally
            {
                if (sqlDataReader != null && !sqlDataReader.IsClosed)
                {
                    sqlDataReader.Close();
                }
            }
            return userGemStones;
        }

        public bool UpdateGemStoneInfo(UserGemStone g)
        {
            bool flag = false;
            try
            {
                SqlParameter[] sqlParameter = new SqlParameter[]
                {
                    new SqlParameter("@ID", (object)g.ID),
                    new SqlParameter("@UserID", (object)g.UserID),
                    new SqlParameter("@FigSpiritId", (object)g.FigSpiritId),
                    new SqlParameter("@FigSpiritIdValue", g.FigSpiritIdValue),
                    new SqlParameter("@EquipPlace", (object)g.EquipPlace),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                sqlParameter[5].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UpdateGemStoneInfo", sqlParameter);
                flag = true;
            }
            catch (Exception exception1)
            {
                Exception exception = exception1;
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateGemStoneInfo", exception);
                }
            }
            return flag;
        }

        public bool AddUserGemStone(UserGemStone item)
        {
            bool value = false;
            try
            {
                SqlParameter[] sqlParameter = new SqlParameter[] { new SqlParameter("@ID", (object)item.ID), null, null, null, null, null };
                sqlParameter[0].Direction = ParameterDirection.Output;
                sqlParameter[1] = new SqlParameter("@UserID", (object)item.UserID);
                sqlParameter[2] = new SqlParameter("@FigSpiritId", (object)item.FigSpiritId);
                sqlParameter[3] = new SqlParameter("@FigSpiritIdValue", item.FigSpiritIdValue);
                sqlParameter[4] = new SqlParameter("@EquipPlace", (object)item.EquipPlace);
                sqlParameter[5] = new SqlParameter("@Result", SqlDbType.Int);
                sqlParameter[5].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_Users_GemStones_Add", sqlParameter);
                value = (int)sqlParameter[5].Value == 0;
                item.ID = (int)sqlParameter[0].Value;
                item.IsDirty = false;
            }
            catch (Exception exception1)
            {
                Exception exception = exception1;
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            return value;
        }

        public List<UserAvatarCollectionInfo> GetSingleAvatarCollect(int userId)
        {
            SqlDataReader sqlDataReader = null;
            List<UserAvatarCollectionInfo> list = new List<UserAvatarCollectionInfo>();
            try
            {
                SqlParameter[] array = new SqlParameter[]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                array[0].Value = userId;
                this.db.GetReader(ref sqlDataReader, "SP_Get_AvatarCollect", array);
                UserAvatarCollectionInfo item = new UserAvatarCollectionInfo();
                while (sqlDataReader.Read())
                {
                    item = new UserAvatarCollectionInfo
                    {
                        ID = (int)sqlDataReader["ID"],
                        AvatarID = (int)sqlDataReader["AvatarID"],
                        UserID = (int)sqlDataReader["UserID"],
                        Sex = (int)sqlDataReader["Sex"],
                        IsActive = (bool)sqlDataReader["IsActive"],
                        Data = (string)sqlDataReader["Data"],
                        TimeStart = (DateTime)sqlDataReader["TimeStart"],
                        TimeEnd = (DateTime)sqlDataReader["TimeEnd"],
                        IsExit = (bool)sqlDataReader["IsExit"]
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_Get_AllDressModel", exception);
                }
            }
            finally
            {
                if (sqlDataReader != null && !sqlDataReader.IsClosed)
                {
                    sqlDataReader.Close();
                }
            }
            return list;
        }

        public bool AddUserAvatarCollect(UserAvatarCollectionInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] array = new SqlParameter[10];
                array[0] = new SqlParameter("@ID", item.ID);
                array[0].Direction = ParameterDirection.Output;
                array[1] = new SqlParameter("@UserID", item.UserID);
                array[2] = new SqlParameter("@AvatarID", item.AvatarID);
                array[3] = new SqlParameter("@Sex", item.Sex);
                array[4] = new SqlParameter("@IsActive", item.IsActive);
                array[5] = new SqlParameter("@Data", item.Data);
                array[6] = new SqlParameter("@TimeStart", item.TimeStart.ToString("MM/dd/yyyy hh:mm:ss"));
                array[7] = new SqlParameter("@TimeEnd", item.TimeEnd.ToString("MM/dd/yyyy hh:mm:ss"));
                array[8] = new SqlParameter("@IsExit", item.IsExit);
                array[9] = new SqlParameter("@Result", SqlDbType.Int);
                array[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_AvatarCollect_Add", array);
                result = ((int)array[9].Value == 0);
                item.ID = (int)array[0].Value;
                item.IsDirty = false;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            return result;
        }

        public bool UpdateUserAvatarCollect(UserAvatarCollectionInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] array = new SqlParameter[]
                {
                    new SqlParameter("@ID", item.ID),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@AvatarID", item.AvatarID),
                    new SqlParameter("@Sex", item.Sex),
                    new SqlParameter("@IsActive", item.IsActive),
                    new SqlParameter("@Data", item.Data),
                    new SqlParameter("@TimeStart", item.TimeStart.ToString("MM/dd/yyyy hh:mm:ss")),
                    new SqlParameter("@TimeEnd", item.TimeEnd.ToString("MM/dd/yyyy hh:mm:ss")),
                    new SqlParameter("@IsExit", item.IsExit),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                array[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_AvatarCollect_Update", array);
                result = ((int)array[9].Value == 0);
                item.IsDirty = false;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_AvatarCollect_Update", exception);
                }
            }
            return result;
        }

        public List<UserLeagueInfo> GetSingleUserLeague(int userId)
        {
            SqlDataReader sqlDataReader = null;
            List<UserLeagueInfo> list = new List<UserLeagueInfo>();
            try
            {
                SqlParameter[] array = new SqlParameter[]
                {
                    new SqlParameter("@UserID", SqlDbType.Int, 4)
                };
                array[0].Value = userId;
                this.db.GetReader(ref sqlDataReader, "SP_GetSingleUserLeague", array);
                UserLeagueInfo item = new UserLeagueInfo();
                while (sqlDataReader.Read())
                {
                    item = new UserLeagueInfo
                    {
                        UserID = (int)sqlDataReader["UserID"],
                        RankID = (int)sqlDataReader["RankID"],
                        Point = (int)sqlDataReader["Point"],
                        Win = (int)sqlDataReader["Win"],
                        Lose = (int)sqlDataReader["Lose"],
                        IsBanned = (bool)sqlDataReader["IsBanned"],
                        ForbidDate = (DateTime)sqlDataReader["ForbidDate"],
                        ForbidReason = (string)sqlDataReader["ForbidDate"],
                    };
                    list.Add(item);
                }
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_GetSingleUserLeague", exception);
                }
            }
            finally
            {
                if (sqlDataReader != null && !sqlDataReader.IsClosed)
                {
                    sqlDataReader.Close();
                }
            }
            return list;
        }

        public bool AddUserLeague(UserLeagueInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] array = new SqlParameter[10];
                array[0] = new SqlParameter("@ID", item.ID);
                array[0].Direction = ParameterDirection.Output;
                array[1] = new SqlParameter("@UserID", item.UserID);
                array[2] = new SqlParameter("@RankID", item.RankID);
                array[3] = new SqlParameter("@Point", item.Point);
                array[4] = new SqlParameter("@Win", item.Win);
                array[5] = new SqlParameter("@Lose", item.Lose);
                array[6] = new SqlParameter("@IsBanned", item.IsBanned);
                array[7] = new SqlParameter("@ForbidDate", item.ForbidDate.ToString("MM/dd/yyyy hh:mm:ss"));
                array[8] = new SqlParameter("@ForbidReason", item.ForbidReason);
                array[9] = new SqlParameter("@Result", SqlDbType.Int);
                array[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserLeague_Add", array);
                result = ((int)array[9].Value == 0);
                item.ID = (int)array[0].Value;
                item.IsDirty = false;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("Init", exception);
                }
            }
            return result;
        }

        public bool UpdateUserLeague(UserLeagueInfo item)
        {
            bool result = false;
            try
            {
                SqlParameter[] array = new SqlParameter[]
                {
                    new SqlParameter("@ID", item.ID),
                    new SqlParameter("@UserID", item.UserID),
                    new SqlParameter("@RankID", item.RankID),
                    new SqlParameter("@Point", item.Point),
                    new SqlParameter("@Win", item.Win),
                    new SqlParameter("@Lose", item.Lose),
                    new SqlParameter("@IsBanned", item.IsBanned),
                    new SqlParameter("@ForbidDate", item.ForbidDate.ToString("MM/dd/yyyy hh:mm:ss")),
                    new SqlParameter("@ForbidReason", item.ForbidReason),
                    new SqlParameter("@Result", SqlDbType.Int)
                };
                array[9].Direction = ParameterDirection.ReturnValue;
                this.db.RunProcedure("SP_UserLeague_Update", array);
                result = ((int)array[9].Value == 0);
                item.IsDirty = false;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UserLeague_Update", exception);
                }
            }
            return result;
        }

        public bool RenamesBatch()
        {
            bool result = false;
            try
            {
                result = db.RunProcedure("Sp_Renames_Batch");
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init Sp_Renames_Batch", e);
            }
            return result;
        }
    }
}
