class ObscenityValidator < ActiveModel::EachValidator
  # Error messages
  # TODO: put these in a table and add a randomizer
  PHRASES = [
    "should be, as wise and mindful, it must remain, hmm.",
    "should always be above reproach, I deduce.",
    "should echo the warmth of a friendly neighborhood, indeed.",
    "must never be served with a side of unsavory language!",
    "should be as spellbinding yet appropriate, much like the words of a headmaster.",
    "should be nothing short of practically perfect in every way.",
    "should bear the honor and valor of a true leader, don't you agree?",
    "ought to paint only the happiest of words, like a serene landscape.",
    "must be strong and valiant, yet gentle and kind-hearted.",
    "should swing through the city with words as responsible as a hero's deeds.",
    "ought to journey through language with the heart of an unassuming hero.",
    "should be as logical and respectful, much like a science officer's report.",
    "needs to reflect the care and empathy of a nurturing soul.",
    "should roar with pride yet maintain the grace of the savanna's king.",
    "ought to jingle with joy and goodwill, like a merry holiday tune.",
    "should be as colorful and friendly as a beloved neighborhood of diverse friends.",
    "must resonate with the courage and nobility of a young wizard's charm.",
    "ought to be as adventurous and respectful as an archaeologist's quest.",
    "should embody the rebellion and grace of a galactic princess.",
    "needs to whisper with the gentleness and wisdom of a wise forest spirit.",
    "ought to bubble with the harmony and joy of an underwater realm.",
    "should be as quirky and kind as the words of a time-traveling explorer.",
    "needs the integrity and bravery of a steadfast defender."
  ].freeze

  # validate each attribute passed in via validator
  def validate_each(record, attribute, value)
    # Replace this with your obscenity check logic
    if value.present? && contains_obscene_word?(value)
      # record.errors.add(attribute, "Test error")
      record.errors.add(attribute, PHRASES.sample)
    end
  end

  private

  def contains_obscene_word?(value)
    ProfanityFilter::Base.profane?(value)
  end
end
