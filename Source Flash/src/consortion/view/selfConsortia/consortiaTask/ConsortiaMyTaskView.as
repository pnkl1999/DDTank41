package consortion.view.selfConsortia.consortiaTask
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionSkillInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ConsortiaMyTaskView extends Sprite implements Disposeable
   {
       
      
      private var _taskInfo:ConsortiaTaskInfo;
      
      private var _vbox:VBox;
      
      private var _finishItemList:Vector.<ConsortiaMyTaskFinishItem>;
      
      private var _myFinishTxt:FilterFrameText;
      
      private var _expTxt:FilterFrameText;
      
      private var _offerTxt:FilterFrameText;
      
      private var _richesTxt:FilterFrameText;
      
      private var _skillNameTxt:FilterFrameText;
      
      private var _contentTxt1:FilterFrameText;
      
      private var _contentTxt2:FilterFrameText;
      
      private var _contentTxt3:FilterFrameText;
      
      public function ConsortiaMyTaskView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc5_:ConsortiaMyTaskFinishItem = null;
         this._finishItemList = new Vector.<ConsortiaMyTaskFinishItem>();
         var _loc1_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("consortion.task.bgI");
         var _loc2_:MutipleImage = ComponentFactory.Instance.creatComponentByStylename("consortion.task.bgII");
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("consortion.task.vboxI");
         this._myFinishTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.MyfinishTxt");
         this._expTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.EXPTxt");
         this._offerTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.MoneyTxt");
         this._richesTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.caiTxt");
         this._skillNameTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.task.SkillTxt");
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.conortionTask.FontContent");
         this._contentTxt1 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt1");
         this._contentTxt2 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt2");
         this._contentTxt3 = ComponentFactory.Instance.creatComponentByStylename("consortion.task.contentTxt3");
         var _loc4_:int = 0;
         while(_loc4_ < 3)
         {
            _loc5_ = ComponentFactory.Instance.creatCustomObject("ConsortiaMyTaskFinishItem");
            this._finishItemList.push(_loc5_);
            this._vbox.addChild(_loc5_);
            _loc4_++;
         }
         addChild(_loc1_);
         addChild(_loc2_);
         addChild(this._vbox);
         addChild(this._myFinishTxt);
         addChild(this._expTxt);
         addChild(this._offerTxt);
         addChild(this._richesTxt);
         addChild(this._skillNameTxt);
      }
      
      private function initEvents() : void
      {
      }
      
      private function removeEvents() : void
      {
      }
      
      private function update() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._finishItemList.length)
         {
            this._finishItemList[_loc1_].update(this._taskInfo.itemList[_loc1_]["taskType"],this._taskInfo.itemList[_loc1_]["content"],this._taskInfo.itemList[_loc1_]["currenValue"],this._taskInfo.itemList[_loc1_]["targetValue"]);
            _loc1_++;
         }
         this._expTxt.text = this._taskInfo.exp.toString();
         this._offerTxt.text = this._taskInfo.offer.toString();
         this._richesTxt.text = this._taskInfo.riches.toString();
         var _loc2_:ConsortionSkillInfo = ConsortionModelControl.Instance.model.getSkillInfoByID(this._taskInfo.buffID);
         if(_loc2_ != null)
         {
            this._skillNameTxt.text = _loc2_.name + " *1天";
         }
         this._contentTxt1.text = "1. " + this._taskInfo.itemList[0]["content"];
         this._contentTxt2.text = "2. " + this._taskInfo.itemList[1]["content"];
         this._contentTxt3.text = "3. " + this._taskInfo.itemList[2]["content"];
         var _loc3_:int = int((this._taskInfo.itemList[0]["finishValue"] + this._taskInfo.itemList[1]["finishValue"] + this._taskInfo.itemList[2]["finishValue"]) / (this._taskInfo.itemList[0]["targetValue"] + this._taskInfo.itemList[1]["targetValue"] + this._taskInfo.itemList[2]["targetValue"]) * 100);
         this._myFinishTxt.text = _loc3_ + "%";
      }
      
      public function set taskInfo(param1:ConsortiaTaskInfo) : void
      {
         this._taskInfo = param1;
         this.update();
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         this._taskInfo = null;
         var _loc1_:int = 0;
         while(this._finishItemList != null && _loc1_ < this._finishItemList.length)
         {
            ObjectUtils.disposeObject(this._finishItemList[_loc1_]);
            _loc1_++;
         }
         this._finishItemList = null;
         if(this._vbox)
         {
            ObjectUtils.disposeObject(this._vbox);
         }
         this._vbox = null;
         if(this._myFinishTxt)
         {
            ObjectUtils.disposeObject(this._myFinishTxt);
         }
         this._myFinishTxt = null;
         if(this._expTxt)
         {
            ObjectUtils.disposeObject(this._expTxt);
         }
         this._expTxt = null;
         if(this._offerTxt)
         {
            ObjectUtils.disposeObject(this._offerTxt);
         }
         this._offerTxt = null;
         if(this._richesTxt)
         {
            ObjectUtils.disposeObject(this._richesTxt);
         }
         this._richesTxt = null;
         if(this._skillNameTxt)
         {
            ObjectUtils.disposeObject(this._skillNameTxt);
         }
         this._skillNameTxt = null;
         if(this._contentTxt1)
         {
            ObjectUtils.disposeObject(this._contentTxt1);
         }
         this._contentTxt1 = null;
         if(this._contentTxt2)
         {
            ObjectUtils.disposeObject(this._contentTxt2);
         }
         this._contentTxt2 = null;
         if(this._contentTxt3)
         {
            ObjectUtils.disposeObject(this._contentTxt3);
         }
         this._contentTxt3 = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
