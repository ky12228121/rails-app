class QuestionsController < ApplicationController
  # 質問一覧表示
  def index
    @questions = Question.all
    p @questions
  end

  # 質問詳細表示
  def show
    p params[:id]
    @question = Question.find(params[:id])
  end

  # 質問作成
  def new
    @question = Question.new
  end

  # 質問登録
  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # 質問編集
  def edit
    @question = Question.find(params[:id])
  end

  # 質問更新
  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to @question
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # 質問削除
  def destroy; end

  private

  def question_params
    params.require(:question).permit(:title, :name, :content)
  end
end
