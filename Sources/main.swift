// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

import ArgumentParser
import PDFKit


func mergePDFs(inputPaths: [String], outputPath: String) throws {
    // Create a new PDFDocument to hold the merged PDFs
    let mergedPDF = PDFDocument()

    // Iterate over the inputPaths array and add each PDF file to the mergedPDF document
    for path in inputPaths {
        if let pdf = PDFDocument(url: URL(fileURLWithPath: path)) {
            for i in 0..<pdf.pageCount {
                if let page = pdf.page(at: i) {
                    mergedPDF.insert(page, at: mergedPDF.pageCount)
                }
            }

            print("Info: \(path) inserted")
        } else {
            throw NSError(domain: "com.example.pdfkit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create PDF document from file at path \(path)"])
        }
    }

    // Write the merged PDF document to the output path
    mergedPDF.write(toFile: outputPath)
}

@main
struct Program: ParsableCommand {
    @Argument(help: "Input files")
    var inputFiles: [String]

    @Option(name: .shortAndLong, help: "Output file")
    var outputFile: String = "merged.pdf"

    func run() throws {

        do {
            try mergePDFs(inputPaths: inputFiles, outputPath: outputFile)
            print("Success: \(outputFile) created.")
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}
