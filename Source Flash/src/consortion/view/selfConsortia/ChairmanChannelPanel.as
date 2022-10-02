package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModelControl;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ChairmanChannelPanel extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _declaration:BaseButton;
      
      private var _jobManage:BaseButton;
      
      private var _transfer:BaseButton;
      
      private var _upGrade:BaseButton;
      
      private var _mail:BaseButton;
      
      private var _task:BaseButton;
      
      public function ChairmanChannelPanel()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.bg");
         this._declaration = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.declaration");
         this._jobManage = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.jobManage");
         this._transfer = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.transfer");
         this._upGrade = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.upGrade");
         this._mail = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.mail");
         this._task = ComponentFactory.Instance.creatComponentByStylename("consortion.chairmanChannel.task");
         addChild(this._bg);
         addChild(this._declaration);
         addChild(this._jobManage);
         addChild(this._transfer);
         addChild(this._upGrade);
         addChild(this._mail);
         addChild(this._task);
      }
      
      private function initEvent() : void
      {
         this._upGrade.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._transfer.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._jobManage.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._declaration.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._mail.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._task.addEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function removeEvent() : void
      {
         this._upGrade.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._transfer.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._jobManage.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._declaration.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._mail.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._task.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:ConsortionUpGradeFrame = null;
         var _loc3_:ConsortionTrasferFrame = null;
         var _loc4_:ConsortionJobManageFrame = null;
         var _loc5_:ConsortionDeclareFrame = null;
         var _loc6_:ConsortionMailFrame = null;
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._upGrade:
               _loc2_ = ComponentFactory.Instance.creatComponentByStylename("consortionUpGradeFrame");
               LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._transfer:
               _loc3_ = ComponentFactory.Instance.creatComponentByStylename("consortionTrasferFrame");
               LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._jobManage:
               _loc4_ = ComponentFactory.Instance.creatComponentByStylename("consortionJobManageFrame");
               LayerManager.Instance.addToLayer(_loc4_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               ConsortionModelControl.Instance.loadDutyList(ConsortionModelControl.Instance.dutyListComplete,PlayerManager.Instance.Self.ConsortiaID);
               break;
            case this._declaration:
               _loc5_ = ComponentFactory.Instance.creatComponentByStylename("consortionDeclareFrame");
               LayerManager.Instance.addToLayer(_loc5_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._mail:
               _loc6_ = ComponentFactory.Instance.creatComponentByStylename("consortionMailFrame");
               LayerManager.Instance.addToLayer(_loc6_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
               break;
            case this._task:
               ConsortionModelControl.Instance.TaskModel.showReleaseFrame();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._bg = null;
         this._declaration = null;
         this._jobManage = null;
         this._transfer = null;
         this._upGrade = null;
         this._mail = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
