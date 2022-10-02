using Game.Base.Packets;
using Game.Server.GameObjects;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Bussiness;
using Game.Server.ConsortiaTask.Data;

namespace Game.Server.ConsortiaTask
{
    public class ConsortiaTaskPacketsOut
    {
        public void SendSumbitTask(GamePlayer player, bool status)
        {
            GSPacketIn pkg = new GSPacketIn(129);
            pkg.WriteByte(22); // CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE
            pkg.WriteByte((byte)ConsortiaTaskType.SUMBIT_TASK);
            pkg.WriteBoolean(status);
            player.SendTCP(pkg);
        }

        public void SendReleaseTaskTest(GamePlayer player) // этот пакет в итоге не нужен
        {
            GSPacketIn pkg = new GSPacketIn(129);
            pkg.WriteByte(22); // CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE
            pkg.WriteByte((byte)ConsortiaTaskType.RELEASE_TASK);
            pkg.WriteInt(3); // _loc9_ = _loc2_.readInt(); lenght of array

            pkg.WriteInt(1);//_loc11_ = _loc2_.readInt();
            pkg.WriteString("Test 01");//_loc12_ = _loc2_.readUTF();

            pkg.WriteInt(2);//_loc11_ = _loc2_.readInt();
            pkg.WriteString("Test 02");//_loc12_ = _loc2_.readUTF();

            pkg.WriteInt(3);//_loc11_ = _loc2_.readInt();
            pkg.WriteString("Test 03");//_loc12_ = _loc2_.readUTF();

            player.SendTCP(pkg);
        }

        public void SendTaskInfo(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn(129);
            pkg.WriteByte(22); // CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE
            pkg.WriteByte((byte)ConsortiaTaskType.GET_TASKINFO);
            pkg.WriteInt(0); // _loc9_ = _loc2_.readInt(); lenght of array
            player.SendTCP(pkg);
        }

        public void SendTaskConditionCompleted(GamePlayer player, string condition)
        {
            GSPacketIn pkg = new GSPacketIn(129, 0);
            pkg.WriteByte(20); // CrazyTankSocketEvent.CONSORTIA_CHAT
            pkg.WriteByte(3);
            pkg.WriteString(""); //_loc4_.sender
            pkg.WriteString(LanguageMgr.GetTranslation(@"Consortia.TaskCondition.Completed", condition)); //_loc4_.msg
            player.SendTCP(pkg);
        }

        public void SendTaskComplete(GamePlayer player)
        {
            GSPacketIn pkg = new GSPacketIn(129, 0);
            pkg.WriteByte(20); // CrazyTankSocketEvent.CONSORTIA_CHAT
            pkg.WriteByte(3);
            pkg.WriteString(""); //_loc4_.sender
            pkg.WriteString(LanguageMgr.GetTranslation(@"Consortia.Task.Complete")); //_loc4_.msg
            player.SendTCP(pkg);
        }

        public void SendTaskUpdate(GamePlayer player, ConsortiaTaskConditionInfo condition)
        {
            GSPacketIn pkg = new GSPacketIn(129);
            pkg.WriteByte(22); // CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE
            pkg.WriteByte((byte)ConsortiaTaskType.UPDATE_TASKINFO);
            pkg.WriteInt(condition.ID);
            pkg.WriteInt(condition.Value);
            pkg.WriteInt(condition.Finish);
            player.SendTCP(pkg);
        }

        public void SendTaskInfo(GamePlayer player, Consortia consortia)
        {
            GSPacketIn pkg = new GSPacketIn(129);
            pkg.WriteByte(22); // CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE
            pkg.WriteByte((byte)ConsortiaTaskType.GET_TASKINFO);
            pkg.WriteInt(consortia.Task.Conditions.Count); // _loc9_ = _loc2_.readInt(); lenght of array
            foreach (var condition in consortia.Task.Conditions)
            {
                /* 
                 * _loc16_ = _loc2_.readInt(); _loc7_["id"] = param1;
                 * _loc17_ = _loc2_.readInt(); _loc7_["taskType"] = param3;
                 * _loc18_ = _loc2_.readUTF(); _loc7_["content"] = param2;
                 * _loc19_ = _loc2_.readInt(); _loc7_["currenValue"] = param4;
                 * _loc20_ = _loc2_.readInt(); _loc7_["targetValue"] = param5;
                 * _loc21_ = _loc2_.readInt(); _loc7_["finishValue"] = param6;
                */
                pkg.WriteInt(condition.ID);
                pkg.WriteInt(condition.Type);
                pkg.WriteString(condition.Content);
                pkg.WriteInt(condition.Value);
                pkg.WriteInt(condition.Target);
                pkg.WriteInt(condition.Finish);
            }
            pkg.WriteInt(consortia.Task.Expirience); // this.taskInfo.exp = _loc2_.readInt();
            pkg.WriteInt(consortia.Task.Offer); // this.taskInfo.offer = _loc2_.readInt();
            pkg.WriteInt(consortia.Task.Contribution); // this.taskInfo.contribution = _loc2_.readInt();
            pkg.WriteInt(consortia.Task.Riches); // this.taskInfo.riches = _loc2_.readInt();
            pkg.WriteInt(consortia.Task.BuffID); // this.taskInfo.buffID = _loc2_.readInt(); бафф награда
            pkg.WriteDateTime(consortia.Task.BeginTime); // this.taskInfo.beginTime = _loc2_.readDate(); когда началась задача?
            pkg.WriteInt(consortia.Task.Time); // this.taskInfo.time = _loc2_.readInt(); в минутах
            pkg.WriteInt(consortia.Task.Level); // this.taskInfo.level = _loc2_.readInt(); уровень задачи
            player.SendTCP(pkg);
        }

        public void SendTaskInfoTest(GamePlayer player, ConsortiaTaskInfo task)
        {
            GSPacketIn pkg = new GSPacketIn(129);
            pkg.WriteByte(22); // CrazyTankSocketEvent.CONSORTIA_TASK_RELEASE
            pkg.WriteByte((byte)ConsortiaTaskType.GET_TASKINFO);
            pkg.WriteInt(3); // _loc9_ = _loc2_.readInt(); lenght of array

            /* 
             * _loc16_ = _loc2_.readInt(); _loc7_["id"] = param1;
             * _loc17_ = _loc2_.readInt(); _loc7_["taskType"] = param3;
             * _loc18_ = _loc2_.readUTF(); _loc7_["content"] = param2;
             * _loc19_ = _loc2_.readInt(); _loc7_["currenValue"] = param4;
             * _loc20_ = _loc2_.readInt(); _loc7_["targetValue"] = param5;
             * _loc21_ = _loc2_.readInt(); _loc7_["finishValue"] = param6;
            */

            pkg.WriteInt(1);
            pkg.WriteInt(2);
            pkg.WriteString("Тест задача 1");
            pkg.WriteInt(0);
            pkg.WriteInt(3);
            pkg.WriteInt(4);

            pkg.WriteInt(2);
            pkg.WriteInt(2);
            pkg.WriteString("Тест задача 2");
            pkg.WriteInt(0);
            pkg.WriteInt(3);
            pkg.WriteInt(3);

            pkg.WriteInt(3);
            pkg.WriteInt(3);
            pkg.WriteString("Тест задача 3");
            pkg.WriteInt(0);
            pkg.WriteInt(1);
            pkg.WriteInt(3);

            pkg.WriteInt(20000); // this.taskInfo.exp = _loc2_.readInt();
            pkg.WriteInt(4000); // this.taskInfo.offer = _loc2_.readInt();
            pkg.WriteInt(40); // this.taskInfo.contribution = _loc2_.readInt();
            pkg.WriteInt(400000); // this.taskInfo.riches = _loc2_.readInt();
            pkg.WriteInt(0); // this.taskInfo.buffID = _loc2_.readInt(); бафф награда
            pkg.WriteDateTime(DateTime.Now); // this.taskInfo.beginTime = _loc2_.readDate(); когда началась задача?
            pkg.WriteInt(4); // this.taskInfo.time = _loc2_.readInt(); в минутах
            pkg.WriteInt(5); // this.taskInfo.level = _loc2_.readInt(); уровень задачи

            player.SendTCP(pkg);
        }
    }
}
