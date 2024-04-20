module Fastlane
  module Actions
    class UnitTestsAction < Action
      def self.transform_results_to_json(results_string)
        results_hash = eval(results_string)
        
        unless results_hash.is_a?(Hash)
          UI.error("Invalid Input")
          return nil
        end
        
        number_of_passing_tests = results_hash[:number_of_tests] - results_hash[:number_of_failures]
        tests_status = if results_hash[:number_of_failures] == 0
          "🏆 Unit Tests Passed 🏆"
          else
          "⚠️ Unit Tests Failed ⚠️"
        end
        
        formatted_array = [
        tests_status,
        "🛠️ Number Of Tests Run: #{results_hash[:number_of_tests]}",
        "✅ Number Of Passing Tests: #{number_of_passing_tests}",
        "🆘 Number Of Failing Tests: #{results_hash[:number_of_failures]}"
        ]
        
        return formatted_array
        rescue => e
        UI.error("💩 Error Parsing Input: #{e.message} ❌")
        nil
      end
      
      def self.run(values)
        require 'scan'
        manager = Scan::Manager.new
        
        begin
          results = manager.work(values)
          results_string = results.to_s
          json_output = transform_results_to_json(results_string)
          
          UI.message("\n🫠 Test Results:\n#{json_output.join("\n")}")
         
          return json_output
          rescue FastlaneCore::Interface::FastlaneBuildFailure => ex
          raise ex
          rescue => ex
          raise ex if values[:fail_build]
          ensure
          update_lane_context(manager, values)
        end
      end
      
      def self.update_lane_context(manager, values)
        if Scan.cache && (result_bundle_path = Scan.cache[:result_bundle_path])
          Actions.lane_context[SharedValues::SCAN_GENERATED_XCRESULT_PATH] = File.absolute_path(result_bundle_path)
        else
          Actions.lane_context[SharedValues::SCAN_GENERATED_XCRESULT_PATH] = nil
        end
        
        unless values[:derived_data_path].to_s.empty?
          plist_files_before = manager.plist_files_before || []
          Actions.lane_context[SharedValues::SCAN_DERIVED_DATA_PATH] = values[:derived_data_path]
          plist_files_after = manager.test_summary_filenames(values[:derived_data_path])
          all_test_summaries = (plist_files_after - plist_files_before)
          Actions.lane_context[SharedValues::SCAN_GENERATED_PLIST_FILES] = all_test_summaries
          Actions.lane_context[SharedValues::SCAN_GENERATED_PLIST_FILE] = all_test_summaries.last
        end
      end
      
      def self.description
        "Runs Unit Tests On Your Device"
      end
      
      def self.details
        "More Information: https://docs.fastlane.tools/actions/scan/"
      end
      
      def self.return_value
        'Outputs Hash Of Results With The Following Keys: :number_of_tests, :number_of_failures, :number_of_retries, :number_of_tests_excluding_retries, :number_of_failures_excluding_retries'
      end
      
      def self.return_type
        :hash
      end
      
      def self.author
        "Josh Robbins (∩｀-´)⊃━☆ﾟ.*･｡ﾟ"
      end
      
      def self.available_options
        require 'scan'
        FastlaneCore::CommanderGenerator.new.generate(Scan::Options.available_options)
      end
      
      def self.output
        [
        ['SCAN_DERIVED_DATA_PATH', 'The Path To The Derived Data'],
        ['SCAN_GENERATED_PLIST_FILE', 'The Generated Plist File'],
        ['SCAN_GENERATED_PLIST_FILES', 'The Generated Plist Files'],
        ['SCAN_GENERATED_XCRESULT_PATH', 'The Path To The Generated .Xcresult'],
        ['SCAN_ZIP_BUILD_PRODUCTS_PATH', 'The Path To The Zipped Build Products']
        ]
      end
      
      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
      
      def self.category
        :testing
      end
    end
  end
end
