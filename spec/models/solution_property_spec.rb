# frozen_string_literal: true

RSpec.describe SolutionProperty, type: :model do
  specify "all properties are valid", :aggregate_failures do
    described_class.all.each do |property|
      property.valid?

      expect(property).to be_valid, "Expected property #{property.name} to be valid, but got errors: #{property.errors.full_messages.join(', ')}"
    end
  end

  shared_examples_for "a property available to draft and actual" do
    it { is_expected.not_to be_only_for_draft }
    it { is_expected.not_to be_only_for_actual }
    it { is_expected.not_to be_skip_for :anything }
    it { is_expected.not_to be_skip_for :actual }
    it { is_expected.not_to be_skip_for :draft }
  end

  shared_examples_for "actual-only" do
    it { is_expected.to be_only_for_actual }
    it { is_expected.not_to be_only_for_draft }
    it { is_expected.to be_skip_for :draft }
    it { is_expected.not_to be_skip_for :actual }
    it { is_expected.not_to be_skip_for :anything }
  end

  shared_examples_for "draft-only" do
    it { is_expected.to be_only_for_draft }
    it { is_expected.not_to be_only_for_actual }
    it { is_expected.to be_skip_for :actual }
    it { is_expected.not_to be_skip_for :draft }
    it { is_expected.not_to be_skip_for :anything }
  end

  shared_examples_for "an existing property" do
    it { is_expected.to exist }
  end

  shared_examples_for "a non-free-input property" do
    it { is_expected.not_to have_free_input }

    it "does not have a free input property" do
      expect(property.free_input_property).to be_nil
    end

    it "does not have free input accessors" do
      expect(property.free_input_accessors).to eq []
    end
  end

  shared_examples_for "a non-implementation" do
    it { is_expected.not_to be_for_implementation }
    it { is_expected.not_to be_implementation_subproperty }

    it "does not produce an implementation" do
      expect(property.implementation).to be_nil
    end
  end

  shared_examples_for "a non-other property" do
    it { is_expected.not_to be_accepts_other }

    it "does not have an other property" do
      expect(property.other_property).to be_nil
    end
  end

  shared_examples_for "a private export" do
    it { is_expected.not_to be_export_for :public }
    it { is_expected.to be_export_for :admin }
  end

  shared_examples_for "a top-level property" do
    it { is_expected.not_to be_owner }

    it "does not find an owner property" do
      expect(property.owner_property).to be_nil
    end
  end

  shared_examples_for "a non-structured property" do
    it { is_expected.not_to be_structured }
    it { is_expected.not_to have_structured_attr }
    it { is_expected.not_to have_structured_header }
  end

  shared_examples_for "a property that accepts other" do
    it { is_expected.to be_accepts_other }

    it "has an other property" do
      expect(property.other_property).to eq described_class.find(property.free_input_name.to_s)
    end
  end

  shared_examples_for "an other property" do
    it { is_expected.not_to be_accepts_other }

    it "does not have an other property" do
      expect(property.other_property).to be_nil
    end

    it "produces the right field label" do
      expect(property.field_label).to eq property.input_label
    end
  end

  shared_examples_for "an owned property" do
    let(:owner_property_name) { raise 'set this' }
    let(:owner_property) { described_class.find(owner_property_name) }

    it { is_expected.to be_owner }

    it "finds the owner property" do
      expect(property.owner_property).to eq owner_property
    end
  end

  context "with a property that accepts other" do
    subject(:property) { described_class.find("programming_languages") }

    it_behaves_like "an existing property"
    it_behaves_like "a non-implementation"
    it_behaves_like "a non-structured property"
    it_behaves_like "a property that accepts other"
  end

  context "with an other option" do
    subject(:property) { described_class.find("programming_language_other") }

    it_behaves_like "an existing property"
    it_behaves_like "a non-implementation"
    it_behaves_like "a non-structured property"
    it_behaves_like "a non-free-input property"
    it_behaves_like "an other property"
    it_behaves_like "an owned property" do
      let(:owner_property_name) { "programming_languages" }
    end
  end

  describe ".build_raw_connections" do
    it "builds raw connections for all properties without error" do
      expect do
        described_class.build_raw_connections
      end.to execute_safely
    end
  end

  describe ".diff_klass_for" do
    it "finds the right diff class for known properties" do
      expect(described_class.diff_klass_for("programming_languages")).to eq Solutions::Revisions::Diffs::StringArrayDiff
    end

    it "returns a default when it can't find the right diff class" do
      expect(described_class.diff_klass_for("unknown property never found")).to eq Solutions::Revisions::Diffs::UnknownDiff
    end
  end

  describe ".lookup_coded_ext" do
    it "can find coded ext properties" do
      expect(described_class.lookup_coded_ext("981_programming_language_other")).to eq described_class.find("programming_language_other")
    end

    it "raises the expected error when it can't" do
      expect do
        described_class.lookup_coded_ext("unknown value")
      end.to raise_error NoMatchingPatternError
    end
  end

  describe ".write_locale!" do
    attr_reader :raw_path

    around do |example|
      Dir.mktmpdir(["solpoptests"]) do |dir|
        @raw_path = Pathname(dir).join("solution_property_labels.en.yml")
        @raw_path.unlink if @raw_path.exist?

        example.run
      ensure
        FileUtils.remove_entry_secure(raw_path) if raw_path.exist?
        @raw_path = nil
      end
    end

    it "writes the locale file" do
      expect do
        described_class.write_locale!(raw_path:)
      end.to change(raw_path, :exist?).from(false).to(true)
    end
  end
end
