package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import game.gametrainer.TrainerEvent;
   import quest.QuestRewardCell;
   import quest.TaskMainFrame;
   
   public class QuestionView extends Question
   {
       
      
      private var _bmpTransparentBg:Bitmap;
      
      private var _bmpAnswer:Bitmap;
      
      private var _bmpNpc:Bitmap;
      
      private var _mcDot:MovieClip;
      
      private var _index:int;
      
      private var _answer:int;
      
      private var _cell:QuestRewardCell;
      
      private var _item1:QuestionItemView;
      
      private var _item2:QuestionItemView;
      
      public function QuestionView()
      {
         super();
         this.initView();
      }
      
      override public function dispose() : void
      {
         this._item1.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         this._item2.removeEventListener(MouseEvent.CLICK,this.__clickHandler);
         ObjectUtils.disposeAllChildren(this);
         this._bmpTransparentBg = null;
         this._mcDot = null;
         this._bmpAnswer = null;
         this._bmpNpc = null;
         this._cell = null;
         this._item1 = null;
         this._item2 = null;
         super.dispose();
      }
      
      public function setData(param1:int, param2:Array, param3:int, param4:InventoryItemInfo = null) : void
      {
         this._index = param1;
         this._answer = param3;
         txtTitle.text = param2[0];
         this._item1.setData(1,param2[1]);
         this._item2.setData(2,param2[2]);
         this._cell.info = param4;
         if(this._cell.info)
         {
            addToContent(this._cell);
         }
         else if(this._cell.parent)
         {
            this._cell.parent.removeChild(this._cell);
         }
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.gametrainer.view.freshmanQustion");
         txtTip.text = LanguageMgr.GetTranslation("trainer.view.QuestionView.tip");
         txtAward.text = LanguageMgr.GetTranslation("trainer.view.QuestionView.award");
         this._bmpTransparentBg = ComponentFactory.Instance.creatBitmap("asset.trainer.question.transparentBg");
         addToContent(this._bmpTransparentBg);
         this._mcDot = ComponentFactory.Instance.creatCustomObject("trainer.question.dot");
         addToContent(this._mcDot);
         this._bmpAnswer = ComponentFactory.Instance.creatBitmap("asset.trainer.question.answer");
         addToContent(this._bmpAnswer);
         this._bmpNpc = ComponentFactory.Instance.creatBitmap("asset.trainer.question.npc");
         addToContent(this._bmpNpc);
         this._cell = ComponentFactory.Instance.creat("trainer.question.rewardCell");
         this._cell.taskType = TaskMainFrame.NORMAL;
         this._item1 = ComponentFactory.Instance.creatCustomObject("trainer.question.questionItemView");
         this._item1.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         vbox.addChild(this._item1);
         this._item2 = ComponentFactory.Instance.creatCustomObject("trainer.question.questionItemView");
         this._item2.addEventListener(MouseEvent.CLICK,this.__clickHandler);
         vbox.addChild(this._item2);
      }
      
      private function __clickHandler(param1:MouseEvent) : void
      {
         var _loc2_:QuestionItemView = param1.currentTarget as QuestionItemView;
         SoundManager.instance.play("008");
         if(this._answer == _loc2_.index)
         {
            SoundManager.instance.play("1001");
            dispatchEvent(new TrainerEvent(TrainerEvent.CLOSE_FRAME));
         }
         else
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.gametrainer.view.wrongAnwser"));
         }
      }
   }
}
