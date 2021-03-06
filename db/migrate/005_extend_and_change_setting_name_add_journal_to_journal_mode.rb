class ExtendAndChangeSettingNameAddJournalToJournalMode <
  (Rails::VERSION::MAJOR < 5 ? ActiveRecord::Migration : ActiveRecord::Migration[4.2])

  def up
    settings = Setting.plugin_issue_recurring
    settings[:author_id] = settings.delete('author_id').to_i
    settings[:keep_assignee] = settings.delete('keep_assignee') == 'true'
    settings[:journal_mode] = settings.delete('add_journal') == 'true' ? :always : :never
    Setting.plugin_issue_recurring = settings
  end

  def down
    settings = Setting.plugin_issue_recurring
    settings['author_id'] = settings.delete(:author_id).to_s
    settings['keep_assignee'] = 'true' if settings.delete(:keep_assignee)
    settings['add_journal'] = 'true' if [:always, :inplace]
      .include?(settings.delete(:journal_mode))
    Setting.plugin_issue_recurring = settings
  end
end

